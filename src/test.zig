const builtin = @import("builtin");
const std = @import("std");
const testing = std.testing;

const alsa = @import("main.zig");

test "pcm playback" {
    var device: ?*alsa.snd_pcm_t = null;
    try alsa.checkError(alsa.snd_pcm_open(
        &device,
        "default",
        alsa.snd_pcm_stream_t.PLAYBACK,
        0,
    ));

    var hw_params: ?*alsa.snd_pcm_hw_params_t = null;
    try alsa.checkError(alsa.snd_pcm_hw_params_malloc(&hw_params));
    defer alsa.snd_pcm_hw_params_free(hw_params.?);

    try alsa.checkError(alsa.snd_pcm_hw_params_any(device.?, hw_params.?));

    try alsa.checkError(alsa.snd_pcm_hw_params_set_rate_resample(
        device.?,
        hw_params.?,
        1,
    ));

    try alsa.checkError(alsa.snd_pcm_hw_params_set_access(
        device.?,
        hw_params.?,
        alsa.snd_pcm_access_t.RW_INTERLEAVED,
    ));

    try alsa.checkError(alsa.snd_pcm_hw_params_set_format(
        device.?,
        hw_params.?,
        switch (builtin.target.cpu.arch.endian()) {
            .Little => alsa.snd_pcm_format_t.FLOAT_LE,
            .Big => alsa.snd_pcm_format_t.FLOAT_BE,
        },
    ));

    const num_channels = 2;
    try alsa.checkError(alsa.snd_pcm_hw_params_set_channels(
        device.?,
        hw_params.?,
        num_channels,
    ));

    var sample_rate: c_uint = 44100;
    try alsa.checkError(alsa.snd_pcm_hw_params_set_rate_near(
        device.?,
        hw_params.?,
        &sample_rate,
        null,
    ));

    try alsa.checkError(alsa.snd_pcm_hw_params(device.?, hw_params.?));

    var buffer_size: alsa.snd_pcm_uframes_t = undefined;
    try alsa.checkError(alsa.snd_pcm_hw_params_get_buffer_size(
        hw_params.?,
        &buffer_size,
    ));

    var buffer = try std.testing.allocator.alloc(f32, buffer_size * num_channels);
    defer std.testing.allocator.free(buffer);

    const pitch = 440;
    const radians_per_sec = pitch * 2 * std.math.pi;
    const sec_per_frame = 1 / @intToFloat(f32, sample_rate);

    try alsa.checkError(alsa.snd_pcm_prepare(device.?));

    const total_frames = sample_rate;

    var sec_off: f32 = 0;

    var frame: usize = 0;
    while (frame < total_frames) {
        var i: usize = 0;
        while (i < buffer_size) : (i += 1) {
            const s = std.math.sin((sec_off + @intToFloat(f32, frame) * sec_per_frame) * radians_per_sec);
            var channel: usize = 0;
            while (channel < num_channels) : (channel += 1) {
                buffer[i * num_channels + channel] = s;
            }
            frame += 1;
        }

        sec_off = @mod(sec_off + sec_per_frame * @intToFloat(f32, buffer_size), 1.0);

        if (alsa.snd_pcm_writei(
            device.?,
            @ptrCast(*anyopaque, buffer),
            buffer_size,
        ) < 0) {
            try alsa.checkError(alsa.snd_pcm_prepare(device.?));
        }
    }

    std.time.sleep(1e9);

    try alsa.checkError(alsa.snd_pcm_close(device.?));
}

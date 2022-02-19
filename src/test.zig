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
            .Little => alsa.snd_pcm_format_t.S16_LE,
            .Big => alsa.snd_pcm_format_t.S16_BE,
        },
    ));

    try alsa.checkError(alsa.snd_pcm_hw_params_set_channels(
        device.?,
        hw_params.?,
        2,
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

    std.log.warn("buffer size = {}", .{buffer_size});

    try alsa.checkError(alsa.snd_pcm_prepare(device.?));

    try alsa.checkError(alsa.snd_pcm_close(device.?));
}

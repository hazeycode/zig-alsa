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
    alsa.snd_pcm_hw_params_free(hw_params.?);

    try alsa.checkError(alsa.snd_pcm_hw_params_any(device.?, hw_params.?));
}

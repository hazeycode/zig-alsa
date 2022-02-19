const std = @import("std");
const testing = std.testing;

const alsa = @import("main.zig");

test "pcm playback" {
    var handle: ?*alsa.snd_pcm = null;
    try alsa.checkError(alsa.snd_pcm_open(
        &handle,
        "default",
        alsa.snd_pcm_stream.PLAYBACK,
        0,
    ));

    var hw_params: ?*alsa.snd_pcm_hw_params = null;
    try alsa.checkError(alsa.snd_pcm_hw_params_malloc(&hw_params));
    alsa.snd_pcm_hw_params_free(hw_params.?);

    try alsa.checkError(alsa.snd_pcm_hw_params_any(handle.?, hw_params.?));
}

const std = @import("std");
const testing = std.testing;

const alsa = @import("main.zig");

test "pcm playback" {
    var handle: ?*alsa.snd_pcm = null;

    if (alsa.snd_pcm_open(&handle, "default", alsa.snd_pcm_stream.PLAYBACK, 0) < 0) {
        return error.FailedToOpenAlsaPlaybackStream;
    }
}

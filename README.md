# zig-alsa
ALSA (libasound) bindings for Zig

NOTE: This library is developed incrementally and bindings are added on a per-demand basis. Pull requests most welcome!

Example usage:
```zig
const alsa = @import("alsa/asoundlib.zig");

var handle: ?*alsa.snd_pcm = null;

if (alsa.snd_pcm_open(&handle, "default", alsa.snd_pcm_stream.PLAYBACK, 0) < 0) {
    return error.FailedToOpenAlsaPlaybackStream;
}
```

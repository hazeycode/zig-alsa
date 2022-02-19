const std = @import("std");
const off_t = std.c.off_t;

const list = @import("list.zig");
const shmarea = @import("shmarea.zig");
const local = @import("local.zig");

pub const snd_pcm_stream = enum(c_int) {
    PLAYBACK = 0,
    CAPTURE,
};

pub const snd_pcm_access = enum(c_int) {
    MMAP_INTERLEAVED = 0,
    MMAP_NONINTERLEAVED,
    MMAP_COMPLEX,
    RW_INTERLEAVED,
    RW_NONINTERLEAVED,
};

pub const snd_pcm_format = enum(c_int) {
    UNKNOWN = -1,
    S8 = 0,
    U8,
    S16_LE,
    S16_BE,
    U16_LE,
    U16_BE,
    S24_LE,
    S24_BE,
    U24_LE,
    U24_BE,
    S32_LE,
    S32_BE,
    U32_LE,
    U32_BE,
    FLOAT_LE,
    FLOAT_BE,
    FLOAT64_LE,
    FLOAT64_BE,
    IEC958_SUBFRAME_LE,
    IEC958_SUBFRAME_BE,
    MU_LAW,
    A_LAW,
    IMA_ADPCM,
    MPEG,
    GSM,
    SPECIAL = 31,
    S24_3LE = 32,
    S24_3BE,
    U24_3LE,
    U24_3BE,
    S20_3LE,
    S20_3BE,
    U20_3LE,
    U20_3BE,
    S18_3LE,
    S18_3BE,
    U18_3LE,
    U18_3BE,
};

pub const snd_pcm_subformat = enum(c_int) {
    STD = 0,
};

pub const snd_pcm_tstamp = enum(c_int) {
    SND_PCM_TSTAMP_NONE = 0,
    SND_PCM_TSTAMP_ENABLE,
};

pub const snd_pcm_uframes = c_ulong;
pub const snd_pcm_sframes = c_long;

pub const SND_PCM_NONBLOCK: c_int = 0x00000001;
pub const SND_PCM_ASYNC: c_int = 0x00000002;
pub const SND_PCM_NO_AUTO_RESAMPLE: c_int = 0x00010000;
pub const SND_PCM_NO_AUTO_CHANNELS: c_int = 0x00020000;
pub const SND_PCM_NO_AUTO_FORMAT: c_int = 0x00040000;
pub const SND_PCM_NO_SOFTVOL: c_int = 0x00080000;

pub const snd_pcm_rbptr = extern struct {
    master: ?*snd_pcm,
    ptr: ?*volatile snd_pcm_uframes,
    fd: c_int,
    offset: off_t,
    link_dst_count: c_int,
    link_dst: ?*?*snd_pcm,
    private_data: ?*anyopaque,
    changed: ?*anyopaque,
};

pub const snd_pcm_channel_info = extern struct {
    channel: c_uint,
    addr: ?*anyopaque,
    first: c_uint,
    step: c_uint,
    type: enum(c_int) { AREA_SHM, AREA_MMAP, AREA_LOCAL },
    u: extern union {
        shm: struct {
            area: ?*shmarea.snd_shm_area,
            sdmid: c_int,
        },
        mmap: struct {
            fd: c_int,
            offset: off_t,
        },
    },
    reserved: [64]u8,
};

pub const snd_pcm_ops = extern struct {
    close: ?*anyopaque,
    nonblock: ?*anyopaque,
    @"async": ?*anyopaque,
    info: ?*anyopaque,
    hw_refine: ?*anyopaque,
    hw_params: ?*anyopaque,
    hw_free: ?*anyopaque,
    sw_params: ?*anyopaque,
    channel_info: ?*anyopaque,
    dump: ?*anyopaque,
    mmap: ?*anyopaque,
    munmap: ?*anyopaque,
};

pub const snd_pcm_fast_ops = extern struct {
    status: ?*anyopaque,
    prepare: ?*anyopaque,
    reset: ?*anyopaque,
    start: ?*anyopaque,
    drop: ?*anyopaque,
    drain: ?*anyopaque,
    pause: ?*anyopaque,
    state: ?*anyopaque,
    hwsync: ?*anyopaque,
    delay: ?*anyopaque,
    @"resume": ?*anyopaque,
    link: ?*anyopaque,
    link_slaves: ?*anyopaque,
    unlink: ?*anyopaque,
    rewindable: ?*anyopaque,
    rewind: ?*anyopaque,
    forwardable: ?*anyopaque,
    forward: ?*anyopaque,
    writei: ?*anyopaque,
    writen: ?*anyopaque,
    readi: ?*anyopaque,
    readn: ?*anyopaque,
    avail_update: ?*anyopaque,
    mmap_commit: ?*anyopaque,
    htimestamp: ?*anyopaque,
    poll_descriptors_count: ?*anyopaque,
    poll_descriptors: ?*anyopaque,
    poll_reevents: ?*anyopaque,
};

pub const snd_pcm = extern struct {
    open_func: ?*anyopaque,
    name: [*c]u8,
    type: snd_pcm_type,
    stream: snd_pcm_stream,
    mode: c_int,
    minperiodtime: c_long,
    poll_fd_count: c_int,
    poll_fd: c_int,
    poll_events: c_ushort,
    setup_flags: c_int,
    access: snd_pcm_access,
    format: snd_pcm_format,
    subformat: snd_pcm_subformat,
    channels: c_uint,
    rate: c_uint,
    period_size: snd_pcm_uframes,
    period_time: c_uint,
    periods: local.snd_interval,
    tstamp_mode: snd_pcm_tstamp,
    period_step: c_uint,
    avail_min: snd_pcm_uframes,
    period_event: c_int,
    start_threshold: snd_pcm_uframes,
    stop_threshold: snd_pcm_uframes,
    silence_threshold: snd_pcm_uframes,
    silence_size: snd_pcm_uframes,
    boundary: snd_pcm_uframes,
    info: c_uint,
    msbits: c_uint,
    rate_num: c_uint,
    rate_den: c_uint,
    hw_flags: c_uint,
    fifo_size: snd_pcm_uframes,
    buffer_size: snd_pcm_uframes,
    buffer_time: local.snd_interval,
    sample_bits: c_uint,
    frame_bits: c_uint,
    appl: snd_pcm_rbptr,
    hw: snd_pcm_rbptr,
    min_align: snd_pcm_uframes,
    flags: c_uint,
    mmap_channels: ?[*]snd_pcm_channel_info,
    running_areas: ?[*]snd_pcm_channel_area,
    stopped_areas: ?[*]snd_pcm_channel_area,
    ops: ?*const snd_pcm_ops,
    fast_ops: ?*const snd_pcm_fast_ops,
    op_arg: ?*snd_pcm,
    fast_op_arg: ?*snd_pcm,
    private_data: ?*anyopaque,
    async_handlers: list.list_head,
};

pub const snd_pcm_type = enum(c_int) {
    HW = 0,
    HOOKS,
    MULTI,
    FILE,
    NULL,
    SHM,
    INET,
    COPY,
    LINEAR,
    ALAW,
    MULAW,
    ADPCM,
    RATE,
    ROUTE,
    PLUG,
    SHARE,
    METER,
    MIX,
    DROUTE,
    LBSERVER,
    LINEAR_FLOAT,
    LADSPA,
    DMIX,
    JACK,
    DSNOOP,
    DSHARE,
    IEC958,
    SOFTVOL,
    IOPLUG,
    EXTPLUG,
    MMAP_EMUL,
};

pub const snd_pcm_channel_area = extern struct {
    addr: ?*anyopaque,
    first: c_uint,
    step: c_uint,
};

pub extern "asound" fn snd_pcm_open(
    ?*?*snd_pcm,
    [*c]const u8,
    snd_pcm_stream,
    c_int,
) callconv(.C) c_int;

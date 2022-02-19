const list = @import("list.zig");

pub const snd_shm_area = extern struct {
    list: list.list_head,
    shmid: c_int,
    ptr: ?*anyopaque,
    share: c_int,
};

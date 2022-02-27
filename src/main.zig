pub usingnamespace @import("local.zig");
pub usingnamespace @import("pcm.zig");

const snderr = @import("error.zig");
pub usingnamespace snderr;

pub fn checkError(res: c_int) !u32 {
    const std = @import("std");
    if (res < 0) {
        std.log.err("{s}", .{snderr.snd_strerror(res)});
        return error.AlsaError;
    }
    return @intCast(u32, res);
}

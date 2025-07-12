const std = @import("std");

pub const StatusCode = enum(u12) {
    const Self = @This();

    UnknownError = 4000,
    UnknownOpcode,
    DecodeError,
    NotAuthenticated,
    AuthenticationFailed,
    AlreadyAuthenticated,
    InvalidSeq = 4007,
    RateLimited,
    SessionTimedOut,
    InvalidShard,
    ShardingRequired,
    InvalidAPIVersion,
    InvalidIntents,
    DisallowedIntents,

    pub fn jsonStringify(self: Self, w: anytype) !void {
        try w.print("{d}", .{@intFromEnum(self)});
    }
};

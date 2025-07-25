const std = @import("std");

pub const OPCode = enum(u5) {
    const Self = @This();

    Dispatch,
    Heartbeat,
    Identify,
    PresenceUpdate,
    VoiceStateUpdate,
    Resume = 6,
    Reconnect,
    RequestGuildMembers,
    InvalidSession,
    Hello,
    HeartbeatACK,
    RequestSoundboardSounds = 31,

    pub fn jsonStringify(self: Self, w: anytype) !void {
        try w.print("{d}", .{@intFromEnum(self)});
    }
};

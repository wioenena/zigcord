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

test "jsonStringify" {
    const allocator = std.testing.allocator;

    const json = try std.json.stringifyAlloc(allocator, OPCode.Reconnect, .{});
    defer allocator.free(json);

    try std.testing.expectEqualStrings(json, "7");
}

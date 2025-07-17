const std = @import("std");

const Event = @import("../../event.zig").Event;
const UpdatePresence = @import("../../structures/presence_update.zig").PresenceUpdate;

pub fn IdentifyEvent(payload: IdentifyPayload) Event(IdentifyPayload) {
    return Event(IdentifyPayload).init(.Identify, payload, null, null);
}

pub const IdentifyPayload = struct {
    pub const Properties = struct {
        os: []const u8,
        browser: []const u8,
        device: []const u8,
    };

    token: []const u8,
    properties: Properties,
    compress: ?bool,
    large_threshold: ?u8,
    shard: ?[2]u16,
    presence: ?UpdatePresence,
    intents: u32,
};

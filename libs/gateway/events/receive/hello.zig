const Event = @import("../../event.zig").Event;

pub fn HelloEvent() Event(HelloPayload) {
    return Event(HelloPayload);
}

pub const HelloPayload = struct {
    heartbeat_interval: u64,
    _trace: []const []const u8,
};

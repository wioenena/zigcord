const Event = @import("../../event.zig").Event;

pub fn HeartbeatEvent(payload: u32) Event(u32) {
    return Event(u32).init(.Heartbeat, payload, null, null);
}

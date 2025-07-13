const Event = @import("../../event.zig").Event;

pub fn ResumeEvent(payload: ResumePayload) Event(ResumePayload) {
    return Event(ResumePayload).init(.Resume, payload, null, null);
}

pub const ResumePayload = struct {
    token: []const u8,
    session_id: []const u8,
    seq: u32,
};

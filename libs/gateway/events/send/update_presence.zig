const Event = @import("../../event.zig").Event;
const PresenceUpdate = @import("../../structures/presence_update.zig").PresenceUpdate;

pub fn UpdatePresenceEvent(payload: UpdatePresencePayload) Event(UpdatePresencePayload) {
    return Event(UpdatePresencePayload).init(.UpdatePresence, payload, null, null);
}

pub const UpdatePresencePayload = PresenceUpdate;

const Event = @import("../../event.zig").Event;
const Snowflake = @import("../../snowflake.zig").Snowflake;

pub fn UpdateVoiceStateEvent(payload: UpdateVoiceStatePayload) Event(UpdateVoiceStatePayload) {
    return Event(UpdateVoiceStatePayload).init(.UpdateVoiceState, payload, null, null);
}

pub const UpdateVoiceStatePayload = struct {
    guild_id: Snowflake,
    channel_id: ?Snowflake,
    self_mute: bool,
    self_deaf: bool,
};

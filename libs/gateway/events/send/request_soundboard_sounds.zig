const Event = @import("../../event.zig").Event;
const Snowflake = @import("../../snowflake.zig").Snowflake;

pub fn RequestSoundboardSoundsEvent(payload: RequestSoundboardSoundsPayload) Event(RequestSoundboardSoundsPayload) {
    return Event(RequestSoundboardSoundsPayload).init(.RequestSoundboardSounds, payload, null, null);
}

pub const RequestSoundboardSoundsPayload = struct {
    guild_ids: []Snowflake,
};

const Event = @import("../../event.zig").Event;
const Snowflake = @import("../../snowflake.zig").Snowflake;

pub fn RequestGuildMembersEvent(payload: RequestGuildMembersPayload) Event(RequestGuildMembersPayload) {
    return Event(RequestGuildMembersPayload).init(.RequestGuildMembers, payload, null, null);
}

pub const RequestGuildMembersPayload = struct {
    guild_id: Snowflake,
    query: ?[]const u8,
    limit: u32,
    presences: ?bool,
    user_ids: ?[]Snowflake,
    nonce: ?[]const u8,
};

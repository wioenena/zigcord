const User = @import("../../structures/user.zig").User;
const Snowflake = @import("../../snowflake.zig").Snowflake;
const UnavailableGuild = @import("../../structures/guild/unavailable_guild.zig").UnavailableGuild;
const Application = @import("../../structures/application.zig").Applicaton;
const GenericGuild = @import("../../structures/guild/guild.zig").GenericGuild;

pub const ReadyPayload = struct {
    v: u32,
    user: User,
    guilds: []GenericGuild(true),
    session_id: []const u8,
    resume_gateway_url: []const u8,
    shard: ?[2]u32 = null,
    application: struct {
        id: Snowflake,
        flags: u32,
    }, // TODO: Implement Application struct
};

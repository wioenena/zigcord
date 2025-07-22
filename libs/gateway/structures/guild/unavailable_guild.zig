const Snowflake = @import("../../snowflake.zig").Snowflake;

pub const UnavailableGuild = struct {
    id: Snowflake,
    unavailable: bool,
};

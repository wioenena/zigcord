const UnavailableGuild = @import("unavailable_guild.zig").UnavailableGuild;

pub const Guild = struct {};

pub fn GenericGuild(comptime isUnavailable: bool) type {
    return if (isUnavailable) UnavailableGuild else Guild;
}

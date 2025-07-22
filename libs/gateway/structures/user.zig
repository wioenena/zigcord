const Snowflake = @import("../snowflake.zig").Snowflake;

pub const User = struct {
    pub const AvatarDecorationData = struct {
        asset: []const u8,
        sku_id: Snowflake,
    };

    pub const Collectible = struct {
        pub const Nameplate = struct {
            sku_id: Snowflake,
            asset: []const u8,
            label: []const u8,
            palette: []const u8,
        };

        nameplate: ?Nameplate,
    };

    pub const PrimaryGuild = struct {
        identity_guild_id: ?Snowflake,
        identity_enabled: ?bool,
        tag: ?[]const u8,
        badge: ?[]const u8,
    };

    id: Snowflake,
    username: []const u8,
    discriminator: []const u8,
    global_name: ?[]const u8,
    avatar: ?[]const u8,
    bot: ?bool = null,
    system: ?bool = null,
    mfa_enabled: ?bool = null,
    banner: ?[]const u8 = null,
    accent_color: ?u32 = null,
    locale: ?[]const u8 = null,
    verified: ?bool = null,
    email: ?[]const u8 = null,
    flags: ?u32 = null, // TODO: Implement Flags enum
    premium_type: ?u32 = null, // TODO: Implement PremiumType enum
    public_flags: ?u32 = null, // TODO: Implement Flags enum
    avatar_decoration_data: ?AvatarDecorationData = null,
    collectibles: ?Collectible = null,
    primary_guild: ?PrimaryGuild = null,
};

const Snowflake = @import("../snowflake.zig").Snowflake;

pub const Activity = struct {
    pub const Type = enum(u3) {
        Playing,
        Streaming,
        Listening,
        Watching,
        Custom,
        Competing,
    };

    pub const Timestamps = struct {
        start: ?u64,
        end: ?u64,
    };

    pub const Emoji = struct {
        name: []const u8,
        id: ?Snowflake,
        animated: ?bool,
    };

    pub const Party = struct {
        id: ?[]const u8,
        size: ?[2]u32,
    };

    pub const Assets = struct {
        large_image: ?[]const u8,
        large_text: ?[]const u8,
        small_image: ?[]const u8,
        small_text: ?[]const u8,
    };

    pub const Secrets = struct {
        join: ?[]const u8,
        spectate: ?[]const u8,
        match: ?[]const u8,
    };

    pub const Flags = enum(u9) {
        Instance = 1 << 0,
        Join = 1 << 1,
        Spectate = 1 << 2,
        JoinRequest = 1 << 3,
        Sync = 1 << 4,
        Play = 1 << 5,
        PartyPrivacyFriends = 1 << 6,
        PartyPrivacyVoiceChannel = 1 << 7,
        Embedded = 1 << 8,
    };

    pub const Button = struct {
        label: []const u8,
        url: []const u8,
    };

    name: []const u8,
    type: Type,
    url: ?[]const u8,
    created_at: u64,
    timestamps: ?Timestamps,
    application_id: ?Snowflake,
    details: ?[]const u8,
    state: ?[]const u8,
    emoji: ?Emoji,
    party: ?Party,
    assets: ?Assets,
    secrets: ?Secrets,
    instance: ?bool,
    flags: ?Flags,
    buttons: ?[]Button,
};

pub const WebSocketManager = struct {
    pub const Options = struct {
        token: []const u8,
        compress: ?bool = false,
        large_threshold: ?u8 = 250,
        // shard TODO: Implement this
        intents: u32,
    };

    const Self = @This();

    options: Options,

    pub fn init(options: Options) Self {
        return .{ .options = options };
    }
};

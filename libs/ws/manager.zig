const Shard = @import("shard.zig").Shard;
const std = @import("std");
const Logger = @import("zigcord-logger").Logger;

pub const WebSocketManager = struct {
    pub const Options = struct {
        token: []const u8,
        compress: ?bool = false,
        large_threshold: ?u8 = 250,
        // shard TODO: Implement this
        intents: u32,
        allocator: std.mem.Allocator,
        logger: Logger,
    };

    const Self = @This();

    options: Options,

    pub fn init(options: Options) Self {
        return .{ .options = options };
    }

    pub fn connect(self: Self) !void {
        var shard = try Shard.init(self.options.allocator, self, self.options.logger);
        defer shard.deinit();
        try shard.connect();
    }
};

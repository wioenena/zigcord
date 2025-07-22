const std = @import("std");

pub const Snowflake = struct {
    const Self = @This();
    pub const EPOCH: comptime_int = 1420070400000;

    id: u64,

    pub fn init(id: u64) Self {
        return .{ .id = id };
    }

    pub fn getTimestamp(self: Self) u42 {
        return @intCast((self.id >> 22) + Snowflake.EPOCH);
    }

    pub fn getInternalWorkerId(self: Self) u5 {
        return @intCast((self.id & 0x3E0000) >> 17);
    }

    pub fn getInternalProcessId(self: Self) u5 {
        return @intCast((self.id & 0x1F000) >> 12);
    }

    pub fn getIncrement(self: Self) u12 {
        return @intCast(self.id & 0xFFF);
    }

    pub fn jsonParseFromValue(_: std.mem.Allocator, value: std.json.Value, _: std.json.ParseOptions) !Self {
        switch (value) {
            .string => |id| {
                return .{ .id = try std.fmt.parseInt(u64, id, 10) };
            },

            else => return error.UnexpectedToken,
        }

        return undefined;
    }

    pub fn jsonParse(allocator: std.mem.Allocator, source: anytype, options: std.json.ParseOptions) !Self {
        switch (try source.nextAlloc(allocator, options.allocate orelse .alloc_if_needed)) {
            .string => |value| {
                return .{ .id = try std.fmt.parseInt(u64, value, 10) };
            },

            else => return error.UnexpectedToken,
        }
    }

    pub fn jsonStringify(self: Self, w: anytype) !void {
        _ = self;
        _ = w;
    }

    pub fn format(self: Self, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
        try writer.print("{}", .{self.id});
    }
};

test "from json" {
    const allocator = std.testing.allocator;
    const json =
        \\ { "id": "175928847299117063" }
    ;

    const User = struct {
        id: Snowflake,
    };

    const parsed = try std.json.parseFromSlice(User, allocator, json, .{});
    defer parsed.deinit();

    const user = parsed.value;

    try std.testing.expect(user.id.id == 175928847299117063);
}

test "parse" {
    const snowflake = Snowflake.init(175928847299117063);
    const timestamp = snowflake.getTimestamp();
    const internalWorkerId = snowflake.getInternalWorkerId();
    const internalProcessId = snowflake.getInternalWorkerId();
    const increment = snowflake.getInternalWorkerId();

    try std.testing.expect(timestamp == 1462015105796);
    try std.testing.expect(internalWorkerId == 1);
    try std.testing.expect(internalProcessId == 1);
    try std.testing.expect(increment == 1);
}

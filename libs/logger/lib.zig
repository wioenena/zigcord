const std = @import("std");

pub const Logger = struct {
    pub const Level = enum {
        Debug,
        Info,
        Warn,
        Error,
    };

    const Self = @This();

    level: Level,

    pub fn init(level: Level) Self {
        return .{ .level = level };
    }

    pub fn log(self: Self, level: Level, comptime format: []const u8, loc: std.builtin.SourceLocation, args: anytype) void {
        if (@intFromEnum(level) < @intFromEnum(self.level)) return;
        std.debug.print("[{s}] {s}() {s}:{d}:{d} " ++ format ++ "\n", .{ @tagName(level), loc.fn_name, loc.file, loc.line, loc.column } ++ args);
    }

    pub fn debug(self: Self, comptime format: []const u8, loc: std.builtin.SourceLocation, args: anytype) void {
        self.log(.Debug, format, loc, args);
    }

    pub fn info(self: Self, comptime format: []const u8, loc: std.builtin.SourceLocation, args: anytype) void {
        self.log(.Info, format, loc, args);
    }

    pub fn warn(self: Self, comptime format: []const u8, loc: std.builtin.SourceLocation, args: anytype) void {
        self.log(.Warn, format, loc, args);
    }

    pub fn err(self: Self, comptime format: []const u8, loc: std.builtin.SourceLocation, args: anytype) void {
        self.log(.Error, format, loc, args);
    }
};

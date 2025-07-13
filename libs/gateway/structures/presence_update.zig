const StatusType = @import("../status_type.zig").StatusType;
const Activity = @import("activity.zig").Activity;

pub const PresenceUpdate = struct {
    since: ?u64,
    activities: []const Activity,
    status: StatusType,
    afk: bool,
};

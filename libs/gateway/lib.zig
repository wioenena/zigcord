pub const Constants = @import("constants.zig");
pub const Event = @import("event.zig").Event;
pub const OPCode = @import("opcode.zig").OPCode;
pub const StatusCode = @import("status_code.zig").StatusCode;

pub const Events = struct {
    // Send events
    pub const HeartbeatEvent = @import("events/send/heartbeat.zig");
    pub const IdentifyEvent = @import("events/send/identify.zig");
    pub const RequestGuildMembersEvent = @import("events/send/request_guild_members.zig");
    pub const RequestSoundboardsSoundsEvent = @import("events/send/request_soundboard_sounds.zig");
    pub const ResumeEvent = @import("events/send/resume.zig");
    pub const UpdatePresenceEvent = @import("events/send/update_presence.zig");
    pub const UpdateVoiceStateEvent = @import("events/send/update_voice_state.zig");

    // Receive events
    pub const HelloEvent = @import("events/receive/hello.zig");
    pub const ReadyEvent = @import("events/receive/ready.zig");
};

pub const Structures = struct {
    pub const Activity = @import("structures/activity.zig").Activity;
    pub const PresenceUpdate = @import("structures/presence_update.zig").PresenceUpdate;
};

pub const Game_Clocks = struct {
    Seconds_Elapsed: f32,
    // TODO:(Dean): Is there anything else we want to pass here?
};

pub const Game_Memory = struct {
    is_initialized: bool,
    Permanent_Storage_Size: u64,
    Permanent_Storage: *anyopaque, // NOTE:(Dean): REQUIRED to be cleared to 0 on startup
    Transient_Storage_Size: u64,
    Transient_Storage: *anyopaque, // NOTE:(Dean): REQUIRED to be cleared to 0 on startup
};

pub const Game_Offscreen_Buffer = struct {
    memory: *anyopaque,
    width: c_int,
    height: c_int,
    ptich: c_int,
};

pub const Game_Sound_Output_Buffer = struct {
    samples_per_second: c_int,
    sample_count: c_int,
    samples: *anyopaque, // u16
};

// --- Game Input ---
pub const Game_Buttons = enum(u4) {
    Start, // XBox: Start | PlayStation: Start
    Back, // XBox: Back | PlayStation: Select
    North, // XBox: Y | PlayStation: Triangle
    South, // XBox: A | PlayStation: X
    West, // XBox: X | PlayStation: Square
    East, // Xbox: B | PlayStation: Circle
    LeftShoulder, // XBox: Left Bumper | PlayStation: L1
    RightShoulder, // XBox: Right Bumper | PlayStation: R1
};

pub const Game_Button_State = struct {
    transition_count: i32,
    is_down: bool, // NOTE:(Dean): i32?
};

pub const Game_Controller_Input = struct {
    is_analog: bool,
    x_start: f32,
    y_start: f32,
    x_end: f32,
    y_end: f32,
    x_min: f32,
    x_max: f32,
    button_state: [8]Game_Button_State,
};

pub const Game_Input = struct {
    Controllers: [4]Game_Controller_Input,
    // TODO:(Dean): insert clock stuff here
};

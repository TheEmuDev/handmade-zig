const std = @import("std");
const win = std.os.windows;

const BYTE = win.BYTE;
const DWORD = win.DWORD;
const SHORT = win.SHORT;
const WORD = win.WORD;

// XInput Constants
pub const XINPUT_GAMEPAD_DPAD_UP = 0x0001;
pub const XINPUT_GAMEPAD_DPAD_DOWN = 0x0002;
pub const XINPUT_GAMEPAD_DPAD_LEFT = 0x0004;
pub const XINPUT_GAMEPAD_DPAD_RIGHT = 0x0008;
pub const XINPUT_GAMEPAD_START = 0x0010;
pub const XINPUT_GAMEPAD_BACK = 0x0020;
pub const XINPUT_GAMEPAD_LEFT_THUMB = 0x0040;
pub const XINPUT_GAMEPAD_RIGHT_THUMB = 0x0080;
pub const XINPUT_GAMEPAD_LEFT_SHOULDER = 0x0100;
pub const XINPUT_GAMEPAD_RIGHT_SHOULDER = 0x0200;
pub const XINPUT_GAMEPAD_A = 0x1000;
pub const XINPUT_GAMEPAD_B = 0x2000;
pub const XINPUT_GAMEPAD_X = 0x4000;
pub const XINPUT_GAMEPAD_Y = 0x8000;

pub const XUSER_MAX_COUNT = 4;

pub const XINPUT_GAMEPAD = extern struct {
    wButtons: WORD,
    bLeftTrigger: BYTE,
    bRightTrigger: BYTE,
    sThumbLX: SHORT,
    sThumbLY: SHORT,
    sThumbRX: SHORT,
    sThumbRY: SHORT,
};

pub const XINPUT_STATE = extern struct {
    dwPacketNumber: DWORD,
    Gamepad: XINPUT_GAMEPAD,
};

pub const XINPUT_VIBRATION = extern struct {
    wLeftMotorSpeed: WORD,
    wRightMotorSpeed: WORD,
};

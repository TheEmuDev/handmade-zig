// Based on ZWindows
const std = @import("std");

const ATOM = std.os.windows.ATOM;
const BOOL = std.os.windows.BOOL;
const BYTE = std.os.windows.BYTE;
const DWORD = std.os.windows.DWORD;
const FARPROC = std.os.windows.FARPROC;
const GUID = std.os.windows.GUID;
const HBRUSH = std.os.windows.HBRUSH;
const HCURSOR = std.os.windows.HCURSOR;
const HDC = std.os.windows.HDC;
const HICON = std.os.windows.HICON;
const HINSTANCE = std.os.windows.HINSTANCE;
const HMENU = std.os.windows.HMENU;
const HMODULE = std.os.windows.HMODULE;
const HRESULT = std.os.windows.HRESULT;
const HWND = std.os.windows.HWND;
const LONG = std.os.windows.LONG;
const LPARAM = std.os.windows.LPARAM;
const LPCSTR = std.os.windows.LPCSTR;
const LPCWSTR = std.os.windows.LPWSTR;
const LPVOID = std.os.windows.LPVOID;
const LRESULT = std.os.windows.LRESULT;
const RECT = std.os.windows.RECT;
const SHORT = std.os.windows.SHORT;
const SIZE_T = std.os.windows.SIZE_T;
const UINT = std.os.windows.UINT;
const UINT32 = std.os.windows.UINT;
pub const UINT64 = c_ulonglong;
const ULONG = std.os.windows.ULONG;
const WORD = std.os.windows.WORD;
const WPARAM = std.os.windows.WPARAM;

const WINAPI = std.builtin.CallingConvention.winapi;

pub const BI_RGB = 0x0000;
pub const COINIT_MULTITHREADED = 0x3;

pub const CS_VREDRAW = 0x0001;
pub const CS_HREDRAW = 0x0002;
pub const CW_USEDEFAULT = std.math.minInt(c_int);

pub const DIB_RGB_COLORS = 0x00;
pub const ERROR_SUCCESS = 0x0;

pub const PM_REMOVE: UINT = 0x0001;
pub const SRCCOPY: UINT = 0x00CC_0020;

pub const VK_ESCAPE: UINT = 0x001B;
pub const VK_SPACE: UINT = 0x0020;
pub const VK_LEFT: UINT = 0x0025;
pub const VK_UP: UINT = 0x0026;
pub const VK_RIGHT: UINT = 0x0027;
pub const VK_DOWN: UINT = 0x0028;

pub const WM_DESTROY: UINT = 0x0002;
pub const WM_SIZE: UINT = 0x0005;
pub const WM_PAINT: UINT = 0x000F;
pub const WM_CLOSE: UINT = 0x0010;
pub const WM_QUIT: UINT = 0x0012;
pub const WM_ACTIVATEAPP: UINT = 0x001C;
pub const WM_KEYUP: UINT = 0x0101;
pub const WM_KEYDOWN: UINT = 0x0100;
pub const WM_SYSKEYUP: UINT = 0x0105;
pub const WM_SYSKEYDOWN: UINT = 0x0104;

pub const WS_OVERLAPPED: DWORD = 0x0000_0000;
pub const WS_EX_TOPMOST: DWORD = 0x0000_0008;
pub const WS_MAXIMIZEBOX: DWORD = 0x0001_0000;
pub const WS_MINIMIZEBOX: DWORD = 0x0002_0000;
pub const WS_THICKFRAME: DWORD = 0x0004_0000;
pub const WS_SYSMENU: DWORD = 0x0008_0000;
pub const WS_CAPTION: DWORD = 0x00C0_0000;
pub const WS_VISIBLE: DWORD = 0x1000_0000;

pub const WS_OVERLAPPEDWINDOW: DWORD = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX;

pub const BITMAPINFOHEADER = extern struct {
    biSize: DWORD,
    biWidth: LONG,
    biHeight: LONG,
    biPlanes: WORD,
    biBitCount: WORD,
    biCompression: DWORD,
    biSizeImage: DWORD,
    biXPelsPerMeter: LONG,
    biYPelsPerMeter: LONG,
    biClrUsed: DWORD,
    biClrImportant: DWORD,
};

pub const BITMAPINFO = extern struct {
    bmiHeader: BITMAPINFOHEADER,
    bmiColors: [1]RGBQUAD,
};

pub const MSG = extern struct {
    hWnd: ?HWND,
    message: UINT,
    wParam: WPARAM,
    lParam: LPARAM,
    time: DWORD,
    pt: POINT,
    lPrivate: DWORD,
};

pub const PAINTSTRUCT = extern struct {
    hdc: HDC,
    fErase: BOOL,
    rcPaint: RECT,
    fRestore: BOOL,
    fIncUpdate: BOOL,
    rgbReserved: [32:0]BYTE,
};

pub const POINT = extern struct { x: LONG, y: LONG };

pub const RGBQUAD = extern struct {
    rgbBlue: BYTE,
    rgbGreen: BYTE,
    rgbRed: BYTE,
    rgbReserved: BYTE,
};

pub const WNDCLASSEXA = extern struct {
    cbSize: UINT = @sizeOf(WNDCLASSEXA),
    style: UINT,
    lpfnWndProc: WNDPROC,
    cbClsExtra: i32 = 0,
    cbWndExtra: i32 = 0,
    hInstance: HINSTANCE,
    hIcon: ?HICON,
    hCursor: ?HCURSOR,
    hbrBackground: ?HBRUSH,
    lpszMenuName: ?LPCSTR,
    lpszClassName: LPCSTR,
    hIconSm: ?HICON,
};

pub fn SUCCEEDED(return_code: HRESULT) bool {
    if (return_code < 0) {
        std.debug.print("Failed with error code: {x}", .{return_code});
    }

    return return_code >= 0;
}

pub fn FAILED(return_code: HRESULT) bool {
    return return_code < 0;
}

pub const WNDPROC = *const fn (hwnd: HWND, uMsg: UINT, wParam: WPARAM, lparam: LPARAM) callconv(WINAPI) LRESULT;

pub extern "kernel32" fn GetModuleHandleA(lpModuleName: ?LPCSTR) callconv(WINAPI) ?HMODULE;
pub extern "kernel32" fn GetProcAddress(hModule: HMODULE, lpProcName: LPCSTR) callconv(WINAPI) ?FARPROC;
pub extern "kernel32" fn LoadLibraryA(lpLibFileName: LPCSTR) callconv(WINAPI) ?HMODULE;
pub extern "gdi32" fn StretchDIBits(hdc: HDC, xDest: c_int, yDest: c_int, destWidth: c_int, destHeight: c_int, xSrc: c_int, ySrc: c_int, srcWidth: c_int, srcHeight: c_int, bits: LPVOID, bitmapInfo: *const BITMAPINFO, iUsage: UINT, rop: DWORD) callconv(WINAPI) c_int;
pub extern "ole32" fn CoInitializeEx(pvReserved: ?LPVOID, dwCoInit: DWORD) callconv(WINAPI) HRESULT;
pub extern "user32" fn BeginPaint(windowHandle: HWND, paint: *PAINTSTRUCT) callconv(WINAPI) HDC;
pub extern "user32" fn CreateWindowExA(dwExStyle: DWORD, lpClassName: ?LPCSTR, lpWindowName: ?LPCSTR, dwStyle: DWORD, X: c_int, Y: c_int, nWidth: c_int, nHeight: c_int, hWindParent: ?HWND, hMenu: ?HMENU, hInstance: HINSTANCE, lpParam: ?LPVOID) callconv(WINAPI) ?HWND;
pub extern "user32" fn DefWindowProcA(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM) callconv(WINAPI) LRESULT;
pub extern "user32" fn DispatchMessageA(lpMsg: *const MSG) callconv(WINAPI) LRESULT;
pub extern "user32" fn EndPaint(windowHandle: HWND, paint: *const PAINTSTRUCT) callconv(WINAPI) BOOL;
pub extern "user32" fn GetClientRect(windowHandle: HWND, rect: *RECT) callconv(WINAPI) BOOL;
pub extern "user32" fn GetDC(hWnd: HWND) callconv(WINAPI) HDC;
pub extern "user32" fn InvalidateRect(windowHandle: HWND, lpRect: ?*const RECT, bErase: BOOL) callconv(WINAPI) BOOL;
pub extern "user32" fn PeekMessageA(lpMsg: *const MSG, hWnd: ?HWND, wMsgFilterMin: UINT, wMsgFilterMax: UINT, wRemoveMsg: UINT) callconv(WINAPI) BOOL;
pub extern "user32" fn RegisterClassExA(*const WNDCLASSEXA) callconv(WINAPI) ATOM;
pub extern "user32" fn ReleaseDC(hWnd: HWND, hDC: HDC) callconv(WINAPI) c_int;
pub extern "user32" fn TranslateMessage(lpMsg: *const MSG) callconv(WINAPI) BOOL;

pub const IUnknown = extern struct {
    __v: *const VTable,
    pub fn Methods(comptime T: type) type {
        return extern struct {
            pub inline fn QueryInterface(self: *T, guid: *const GUID, outobj: ?*?*anyopaque) HRESULT {
                return @as(*const IUnknown.VTable, @ptrCast(self.__v))
                    .QueryInterface(@as(*IUnknown, @ptrCast(self)), guid, outobj);
            }
            pub inline fn AddRef(self: *T) ULONG {
                return @as(*const IUnknown.VTable, @ptrCast(self.__v)).AddRef(@as(*IUnknown, @ptrCast(self)));
            }
            pub inline fn Release(self: *T) ULONG {
                return @as(*const IUnknown.VTable, @ptrCast(self.__v)).Release(@as(*IUnknown, @ptrCast(self)));
            }
        };
    }

    pub const VTable = extern struct {
        QueryInteface: *const fn (*IUnknown, *const GUID, ?*?*anyopaque) callconv(WINAPI) HRESULT,
        AddRef: *const fn (*IUnknown) callconv(WINAPI) ULONG,
        Release: *const fn (*IUnknown) callconv(WINAPI) ULONG,
    };
};

const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .x86_64,
            .os_tag = .windows,
            .abi = .msvc,
        },
    });

    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "handmade_zig",
        .root_source_file = b.path("src/win32/win32_handmade.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe.subsystem = .Windows;
    exe.entry = .{ .symbol_name = "wWinMainCRTStartup" };

    exe.linkLibC();
    //exe.linkLibCpp();

    exe.linkSystemLibrary("advapi32");
    exe.linkSystemLibrary("comctl32");
    exe.linkSystemLibrary("gdi32");
    exe.linkSystemLibrary("kernel32");
    exe.linkSystemLibrary("Ole32");
    // exe.linkSystemLibrary("msvcrtd");
    //exe.linkSystemLibrary("Scrnsave");
    exe.linkSystemLibrary("user32");
    //exe.linkSystemLibrary("xaudio2_9");
    exe.linkSystemLibrary("xaudio2"); // use with .msvc

    exe.addIncludePath(.{ .cwd_relative = "src" });
    exe.addCSourceFile(.{ .file = b.path("src/win32/xaudio2_wrapper.cpp"), .flags = &.{"-std=c++17"} });

    b.installArtifact(exe);
}

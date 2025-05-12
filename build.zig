const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const platform_dep = b.dependency("platform", .{
        .target = target,
        .optimize = optimize,
        .name = @as([]const u8, "repl"),
        .version = @as([]const u8, "0.0.0"),
    });

    const repl_mod = b.addModule("repl", .{
        .root_source_file = b.path("repl.zig"),
        .target = target,
        .optimize = optimize,
    });

    repl_mod.addImport("utils", platform_dep.module("utils"));

    const repl_test = b.addTest(.{
        .root_module = repl_mod,
    });

    const check = b.step("check", "Semantic analysis");
    check.dependOn(&repl_test.step);

    b.default_step.dependOn(check);
}

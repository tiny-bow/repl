const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const repl_mod = b.addModule("repl", .{
        .root_source_file = b.path("repl.zig"),
        .target = target,
        .optimize = optimize,
    });

    const rg_dep = b.dependency("rg", .{
        .target = target,
        .optimize = optimize,
    });

    repl_mod.addImport("rg", rg_dep.module("rg"));

    const repl_test = b.addTest(.{
        .root_module = repl_mod,
    });

    const check = b.step("check", "Semantic analysis");
    check.dependOn(&repl_test.step);

    b.default_step.dependOn(check);
}

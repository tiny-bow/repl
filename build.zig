const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const repl_mod = b.addModule("repl", .{
        .root_source_file = b.path("repl.zig"),
        .target = target,
        .optimize = optimize,
    });

    if (b.option(bool, "builtin_platform", "use the builtin platform") orelse true) {
        const platform_dep = b.dependency("platform", .{
            .target = target,
            .optimize = optimize,
            .name = @as([]const u8, "repl"),
            .version = @as([]const u8, "0.0.0"),
        });

        repl_mod.addImport("utils", platform_dep.module("utils"));

        const repl_test = b.addTest(.{
            .root_module = repl_mod,
        });

        const check = b.step("check", "Semantic analysis");
        check.dependOn(&repl_test.step);

        b.default_step.dependOn(check);
    }
}

pub fn use_platform(b: *std.Build, utils: *std.Build.Module, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Module {
    const mod = b.createModule(.{
        .root_source_file = b.path("repl.zig"),
        .target = target,
        .optimize = optimize,
    });

    mod.addImport("utils", utils);

    return mod;
}

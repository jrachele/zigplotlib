const std = @import("std");
const Allocator = std.mem.Allocator;

const SVG = @import("../svg/SVG.zig");
const Range = @import("../util/range.zig").Range;

const FigureInfo = @import("FigureInfo.zig");

const Plot = @This();

/// A List of Plot
pub const List = std.ArrayList(Plot);

impl: *const anyopaque,
get_range_x_fn: *const fn(*const anyopaque) Range(f32),
get_range_y_fn: *const fn(*const anyopaque) Range(f32),
draw_fn: *const fn(*const anyopaque, allocator: Allocator, *SVG, FigureInfo) anyerror!void,

pub fn init(
    impl: *const anyopaque,
    get_range_x_fn: *const fn(*const anyopaque) Range(f32),
    get_range_y_fn: *const fn(*const anyopaque) Range(f32),
    draw_fn: *const fn(*const anyopaque, Allocator, *SVG, FigureInfo) anyerror!void,
) Plot {
    return Plot {
        .impl = impl,
        .get_range_x_fn = get_range_x_fn,
        .get_range_y_fn = get_range_y_fn,
        .draw_fn = draw_fn,
    };
}

pub fn get_range_x(self: *const Plot) Range(f32) {
    return self.get_range_x_fn(self.impl);
}

pub fn get_range_y(self: *const Plot) Range(f32) {
    return self.get_range_y_fn(self.impl);
}

pub fn draw(self: *const Plot, allocator: Allocator, svg: *SVG, info: FigureInfo) anyerror!void {
    try self.draw_fn(self.impl, allocator, svg, info);
}
const std = @import("std");
const testing = std.testing;

/// The internal function used by the implementation. You probably don't want this unless
/// you only want to search in a specific part of the sorted array. See [`binSearch`]
/// instead.
pub fn rawBinSearch(comptime T: type, target: T, arr: []const T, start: usize, end: usize) ?usize {
    if (start > end) {
        return null;
    }

    const diff: f32 = @as(f32, @floatFromInt(end)) - @as(f32, @floatFromInt(start));
    const m: usize = @intFromFloat(@as(f32, @floatFromInt(start)) + std.math.floor(diff / 2));

    if (arr[m] < target) {
        return rawBinSearch(T, target, arr, m + 1, end);
    }

    if (arr[m] == target) {
        return m;
    }

    if (arr[m] > target) {
        if (m == 0) {
            return null;
        }

        return rawBinSearch(T, target, arr, start, m - 1);
    }

    unreachable;
}

/// Perform binary search on array `arr`, returning the `target`'s index if found, or
/// returning `null` otherwise.
pub fn binSearch(comptime T: type, target: T, arr: []const T) ?usize {
    if (arr.len == 0) {
        return null;
    }

    return rawBinSearch(T, target, arr, 0, arr.len);
}

test "search for an element" {
    const myArr = [_]u8{ 1, 2, 3, 5, 6, 7 };

    try testing.expect(binSearch(u8, 3, &myArr) == 2);
}

test "search for a non-existent element" {
    const myArr = [_]u8{ 4, 5, 6 };

    try testing.expect(binSearch(u8, 3, &myArr) == null);
}

test "search in an empty slice" {
    const myArr = [_]u8{};

    try testing.expect(binSearch(u8, 5, &myArr) == null);
}

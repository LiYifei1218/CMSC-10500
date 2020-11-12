/*
 * Author: Yifei Li
 * Date: 2020-07-02 22:44:50
 * LastEditTime: 2020-07-06 22:45:07
 * FilePath: /CS105/homeworks/hw5/assignment5.swift
 */

import Foundation

// Problem 1
func intToDigitArray(_ x: Int) -> [Int] {
    assert(x >= 0)
    let str = String(x)
    let arr: [Character] = Array(str)
    var out = [Int]()
    for c in arr {
        out.append(Int(String(c))!)
    }
    return out
}
assert(intToDigitArray(12345) == [1, 2, 3, 4, 5])
assert(intToDigitArray(101) == [1, 0, 1])

// Problem 2
func accumulate<S, T>(_ l: [S], start: T, combiner: (T, S) -> T) -> T {
    var cur: T = start
    for acc in l {
        cur = combiner(cur, acc)
    }
    return cur
}
// these functions are sum, factorial, and reverse
// here we the (+) operator on lists for concatentation
assert(accumulate([1, 2, 3, 4, 5], start: 0, combiner: (+)) == 15)
assert(accumulate([1, 2, 3, 4, 5], start: 1, combiner: (*)) == 120)
assert(accumulate([1, 2, 3, 4, 5], start: [], combiner: { [$1] + $0 }) == [5, 4, 3, 2, 1])

// Problem 3
func map<S, T>(_ f: (S) -> T, onto l: [S]) -> [T] {
    var out = [T]()
    for item in l {
        out.append(f(item))
    }
    return out
}
func filter<T>(_ l: [T], with f: (T) -> Bool) -> [T] {
    var out = [T]()
    for item in l {
        if f(item) {
            out.append(item)
        }
    }
    return out
}
assert(map({ $0 * $0 }, onto: [1, 2, 3, 4, 5]) == [1, 4, 9, 16, 25])
assert(filter([1, 2, 3, 4, 5, 6], with: { $0 % 2 == 0 }) == [2, 4, 6])
assert(map({ $0 + 1 }, onto: [1, 2, 3, 4, 5]) == [2, 3, 4, 5, 6])
assert(filter([-10, -21, 2, 38, 94, -5, 6], with: { $0 > 0 }) == [2, 38, 94, 6])

// Problem 4
func combineDict<S, T>(_ d1: [S: T], _ d2: [S: T], combiner: (T, T) -> T) -> [S: T] {
    var d3 = d1
    for i in d2 {
        if d3[i.key] == nil {
            d3[i.key] = i.value
        } else {
            d3[i.key] = combiner(d3[i.key]!, d2[i.key]!)
        }
    }
    return d3
}
func reduce<S, T>(_ l: [[S: T]], combiner: (T, T) -> T) -> [S: T] {
    return accumulate(l, start: [S: T](), combiner: { combineDict($0, $1, combiner: combiner) })
}
assert(reduce([[Int: Int]](), combiner: (+)) == [:])
assert(reduce([["a": 1], ["b": 1], ["c": 1], ["a": 1], ["c": 1]], combiner: (+)) == ["a": 2, "b":1, "c": 2])
assert(reduce([["a": 1, "d": 8], ["b": 1, "d": 3], ["c": 1], ["a": 1], ["c": 1], ["a": 1], ["a": 1]], combiner: (+)) == ["b": 1, "d": 11, "c": 2, "a": 4])



// Problem 5
let firstArg = { (x: Int, y: Int) in x }
let secondArg = { (x: Int, y: Int) in y }

var extraVariable = 0

func i1() -> Int {
    extraVariable += 1
    return extraVariable
}

func i2() -> Int {
    return 0
}

assert(firstArg(i1(), i2()) != secondArg(i2(), i1()))


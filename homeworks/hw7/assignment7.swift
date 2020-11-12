/*
 * Author: Yifei Li
 * Date: 2020-07-10 23:22:20
 * LastEditTime: 2020-07-11 00:27:25
 * FilePath: /CS105/homeworks/hw7/assignment7.swift
 */
import Foundation
func myReverse<T>(_ l: [T]) -> [T] {
    if l.count == 0 { return []}
    return myReverse(Array(l[1..<l.count]) + Array(arrayLiteral: l[0]))
}
var test = ["1", "2", "3", "4", "5"]

assert(myReverse(test) == ["5", "4", "3", "2", "1"])

func minimumBetween(leftIndex: Int, rightIndex: Int, of l: [Int]) -> Int? {
    if l.isEmpty { return nil }
    assert(leftIndex >= 0 && leftIndex <= l.count)
    assert(rightIndex >= 0 && rightIndex <= l.count)
    assert(leftIndex < rightIndex)
    let mid:Int = (leftIndex + rightIndex) / 2
    return min(minimumBetween(leftIndex: leftIndex, rightIndex: mid, of: l)!, minimumBetween(leftIndex: mid, rightIndex: rightIndex, of: l)!)
}

func minimum(_ l: [Int]) -> Int? {
    return minimumBetween(leftIndex: 0, rightIndex: l.count, of: l)
}

assert(minimum([Int](1...10000).shuffled()) == 1)
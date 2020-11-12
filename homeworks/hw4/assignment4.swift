/*
 * Author: Yifei Li
 * Date: 2020-07-02 02:06:34
 * LastEditTime: 2020-07-02 06:53:23
 * FilePath: /CS105/hw4/assignment4.swift
 */

import Foundation

// Problem 1
func removeAllOccurences(of x: Int, from l: [Int]) -> [Int] {
    var out = l
    for item in out {
        if item == x {
            out.remove(at: out.firstIndex(of: item)!)
        }
    }
    return out
}
assert(removeAllOccurences(of: 3, from: [1, 2, 3, 4, 5]) == [1, 2, 4, 5])
assert(removeAllOccurences(of: 5, from: [5, 5, 5, 5, 5, 5, 5]) == [])
assert(removeAllOccurences(of: -49, from: [-49, 49, 4, 9]) == [49, 4, 9])
assert(removeAllOccurences(of: 4, from: [3, 7, 3, 77, 2, 10]) == [3, 7, 3, 77, 2, 10])

// Problem 2
func unzip(_ xs: [Int]) -> ([Int], [Int]) {
    var out1: [Int] = []
    var out2: [Int] = []
    for i in 0..<xs.count {
        if i % 2 == 0 { out1.append(xs[i]) }
        else { out2.append(xs[i]) }
    }
    return (out1, out2)
}
assert(unzip([Int]()) == ([], []))   // UPDATED 7/1
assert(unzip([0]) == ([0], []))
assert(unzip([0, 1]) == ([0], [1]))
assert(unzip([0, 1, 2]) == ([0, 2], [1]))
assert(unzip([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) == ([0, 2, 4, 6, 8], [1, 3, 5, 7, 9]))

// Problem 3
func whichDictionary(_ s: String, outOf a: [[String: Int]]) -> Int? {
    for dictionary in a {
        if dictionary.keys.contains(s) {
            return a.firstIndex(of: dictionary)
        }
    }
    return nil
}
assert(whichDictionary("test", outOf: [["good": 0, "apple": 1], ["plane": 0, "car": 1]]) == nil)
assert(whichDictionary("test", outOf: [["good": 0, "apple": 1], ["test": 0, "car": 1]]) == 1)
assert(whichDictionary("test", outOf: [["good": 0, "apple": 1], ["plane": 0, "car": 1], ["banana": 0, "car": 1], ["test": 0, "car": 1], ["test": 0, "car": 1]]) == 3)

// Problem 4
func sumOfKeysDict(_ dict:[Int : String]) -> [String : Int] {
    var out = [String : Int]()
    for item in dict {
        if out[item.value] == nil {
            out[item.value] = item.key
        }
        else {
            out[item.value]! += item.key
        }
    }
    return out
}
assert(sumOfKeysDict([1 : "a", 2 : "b"]) == ["a" : 1, "b" : 2])
assert(sumOfKeysDict([1 : "a", 2 : "b", 3 : "b"]) == ["a" : 1, "b" : 5])

// Problem 5 
func pointwiseMax(_ l: [(Int) -> Int]) -> ((Int) -> Int)? {
    var index = 0
    var maxValue = Int.min
    func test(_ n: Int) -> Int{
        for i in 0..<l.count {
            if l[i](n) > maxValue {
                maxValue = l[i](n)
                index = i
            }
        }
        return index
    }
    return test
}
print(pointwiseMax([{ -$0 }, { $0 + 10 }, { 2 * $0 }])!(-200))
print(pointwiseMax([{ -$0 }, { $0 + 10 }, { 2 * $0 }])!(2))
print(pointwiseMax([{ -$0 }, { $0 + 10 }, { 2 * $0 }])!(12))
/* 
 * I can now get the index of the array which that function returns the max value,
 * the above line prints the index 0, 1 and 2.
 * But I still can't figure out how to return the function with that index.
 */

// assert(pointwiseMax([]) == nil)
// assert(pointwiseMax([{ -$0 }, { $0 + 10 }, { 2 * $0 }])!(-200) == 200)
// assert(pointwiseMax([{ -$0 }, { $0 + 10 }, { 2 * $0 }])!(2) == 12)
// assert(pointwiseMax([{ -$0 }, { $0 + 10 }, { 2 * $0 }])!(12) == 24)
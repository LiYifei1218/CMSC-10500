/*
 * Author: Yifei Li
 * Date: 2020-07-16 02:08:21
 * LastEditTime: 2020-07-16 20:36:35
 * FilePath: /CS105/projects/project1/test.swift
 */

// for i in 1...3 {
//     for j in 1...i {
//         for k in 1...j {
//             for l in 1...k {
//                 print(i, j, k, l)
//             }
            
//         }
//     }
// }

// func nextDie(after die: [Int], minSide: Int, maxSide: Int) -> [Int]? {
//     var flag = false
//     func solve(now: Int, arr: [Int]) -> [Int]? {
//         if now > arr.first! {
//             if Array(arr[1...]) == die {
//                 if !flag {
//                     flag = true
//                 } else {
//                     return Array(arr[1...])
//                 }
//             }
//             return nil
//         }
//         for i in minSide...arr.last! {
//             var newArr = arr
//             newArr.append(i)
//             let ans = solve(now: now + 1, arr: newArr)
//             if ans != nil {
//                 return ans
//             }
//         }
//         return nil
//     }
//     return solve(now: 1, arr: [maxSide])
// }


// func solve(now: Int, min: Int, layer: Int, arr: [Int]) {
//     if now > layer {
//         print(arr[1...])
//         return
//     }
//     for i in min...arr.last! {
//         var newArr = arr
//         newArr.append(i)
//         solve(now: now + 1, min: min, layer: layer, arr: newArr)
//     }
// }

// solve(now: 1, min: 1, layer: 4, arr: [4])

func approxChoose(_ n: Int, _ k: Int) -> Double {
    var out = 1.0
    for i in 0..<k {
        out *= (Double(n - i) / Double(k - i))
    }
    return out
}

func approxMultiset(_ n: Int, _ k: Int) -> Double {
    return approxChoose(n + k - 1, k)
}

print(approxMultiset(4, 4))
print(approxMultiset(35, 2))

func isBiggerDie(first: [Int], second: [Int]) -> Bool {
        
        for i in 0..<first.count {
            if first[i] <= second[i] { return false }
        }
        return true
    }

//print(isBiggerDie(first: [4,3,2,2],second: [4,3,2,2]))

typealias Die = [Int]
typealias DieSet = [Die]
typealias Roll = [Int]
typealias Distribution = [Int: Int]

var numberOfSides = 4
var numberOfDice = 2

func firstDie(minSide: Int) -> Die {
    return [Int](repeating: minSide, count: numberOfSides)
}


func nextDie(after die: Die, minSide: Int, maxSide: Int) -> Die? {
    var out = die
    out[out.count - 1] += 1
    for i in (1..<out.count).reversed() {
        if out[i] > out[i - 1] {
            out[i] = minSide
            out[i - 1] += 1
        }
    }
    if out[0] > maxSide { return nil }
    else { return out }
}

func firstDieSet(minSide: Int) -> DieSet {
    return [[Int]](repeating: firstDie(minSide: minSide), count: numberOfDice)
}

func nextDieSet(after dice: DieSet, minSide: Int, maxSide: Int) -> DieSet? {
    func isBiggerDie(first: Die, second: Die) -> Bool {
        for i in 0..<first.count {
            if first[i] < second[i] { return false }
        }
        if first == second { return false }
        return true
    }
    var out = dice
    if nextDie(after: out[out.count - 1], minSide: minSide, maxSide: maxSide) == nil { return nil}
    out[out.count - 1] = nextDie(after: out[out.count - 1], minSide: minSide, maxSide: maxSide)!
    for i in (1..<out.count).reversed() {
        if isBiggerDie(first: out[i], second: out[i - 1]) {
            out[i] = firstDie(minSide: minSide)
            out[i - 1] = nextDie(after: out[i - 1], minSide: minSide, maxSide: maxSide)!
        }
    }
    if isBiggerDie(first: out[0], second: firstDie(minSide: maxSide)) { return nil }
    else { return out }
}


var currentDieSetOrNil: DieSet? = firstDieSet(minSide: 1)
    while let dieSet = currentDieSetOrNil {

        print(dieSet)
        currentDieSetOrNil = nextDieSet(after: dieSet, minSide: 1, maxSide: 4)
        
    }

// var currentDieOrNil: Die? = firstDie(minSide: 1)
//     while let die = currentDieOrNil {

//         print(die)
//         currentDieOrNil = nextDie(after: die, minSide: 1, maxSide: 4)
        
//     }


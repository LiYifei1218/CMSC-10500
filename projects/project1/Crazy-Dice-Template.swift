/*
    Crazy-Dice.swift

    a program which searches for crazy dice (Sicherman-like dice)
    given a number of side and a number of dice

*/

/*
TESTS

crazy dice for two 4-sided dice:
die 1: [5, 3, 3, 1]
die 2: [3, 2, 2, 1]

crazy dice for two 5-sided dice:
[NONE]

crazy dice for two 6-sided dice:
die 1: [8, 6, 5, 4, 3, 1]
die 2: [4, 3, 3, 2, 2, 1]

crazy dice for three 4-sided dice:
die 1: [5, 3, 3, 1]
die 2: [4, 3, 2, 1]
die 3: [3, 2, 2, 1]
*/


import Foundation

var numberOfSides = 6
var numberOfDice = 2
var extraCredit = false

let usageString =
"""
OVERVIEW: Program for Finding Sicherman Dice

USAGE: swift Crazy-Dice.swift

OPTIONS:
    -number=<value>    set the number of dice used in the program to <value>
                       <value> must be a positive integer
                       if not included, the number of dice is 2

    -sides=<value>     set the number of sides on the dice used to <value>
                       <value> must be a positive integer
                       if not included, the number of sides is 6
"""

func main() {
    setParameters()
    printCrazyDice()
}

main()

func printUsage() {
    print(usageString)
    exit(1)
}

func setParameters() {
    func readArg(_ s: String) {
        var str = s
        if str.hasPrefix("-number=") {
            str.removeFirst(8)
            if Int(str) == nil { printUsage() }
            numberOfDice = Int(str)!
        }
        else if str.hasPrefix("-sides=") {
            str.removeFirst(7)
            if Int(str) == nil { printUsage() }
            numberOfSides = Int(str)!
        }
        else { printUsage() }
    }
    if CommandLine.arguments.count > 1 {
        for arg in CommandLine.arguments[1...] {
            readArg(arg)
        }
    }
}

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

func printCrazyDice() {
    if numberOfSides == 2, extraCredit {
        //TODO: fill in code here
        return
    }
    let standardDieSet = DieSet(repeating: [Int](1...numberOfSides).reversed(), count: numberOfDice)
    let standardDistribution = distribution(ofDieSet: standardDieSet)
    let maxSide = numberOfSides * numberOfDice - ((numberOfSides == 6) ? 4 : 3)


    let totalDice = approxMultiset(maxSide, numberOfSides)
    let totalCheck = approxMultiset(Int(totalDice), numberOfDice)

    var percent = 0.0
    var count = 0

    var currentDieSetOrNil: DieSet? = firstDieSet(minSide: 1)
    while let dieSet = currentDieSetOrNil {
        count += 1
        let current = 100 * (Double(count) / Double(totalCheck))
        if current - percent >= 1 {
                percent = current
                print("approximately \(Int(percent))% done...")
        }
        if distribution(ofDieSet: dieSet) == standardDistribution {
            print("""
            -----------------
            crazy dice found!
            -----------------
            """)
            for i in 0..<dieSet.count {
                print("die \(i+1): \(dieSet[i])")
            }
        }
        currentDieSetOrNil = nextDieSet(after: dieSet, minSide: 1, maxSide: maxSide)
    }
}

typealias Die = [Int]
typealias DieSet = [Die]
typealias Roll = [Int]
typealias Distribution = [Int: Int]

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

func firstRoll() -> Roll {
    return [Int](repeating: 0, count: numberOfDice)
}

func nextRoll(after roll: Roll) -> Roll? {
    var out = roll
    for var i in (0..<out.count).reversed() {
        if out[i] >= numberOfSides - 1 {
            out[i] = 0
            i -= 1
        }
        else {
            out[i] += 1
            return out
        }
    }
    return nil
}

func rollValue(ofDieSet dice: DieSet, onRoll roll: Roll) -> Int {
    var out = 0
    for i in 0..<dice.count {
        out += dice[i][roll[i]]
    }
    return out
}

func distribution(ofDieSet dice: DieSet) -> Distribution {
    var roll = firstRoll()
    var out: Distribution = [:]
    while nextRoll(after: roll) != nil {
        let value = rollValue(ofDieSet: dice, onRoll: roll)

        if out[value] != nil {
            out[value]! += 1
        }
        else {
            out[value] = 1
        }
        roll = nextRoll(after: roll)!
    }
    return out
}

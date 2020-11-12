/*
 * Author: Yifei Li
 * Date: 2020-07-12 18:00:20
 * LastEditTime: 2020-07-14 02:11:02
 * FilePath: /CS105/homeworks/hw8/assignment8.swift
 */
// this enumeration uses raw values from the additional reading

enum Peg : String {
    case left = "left peg"
    case middle = "middle peg"
    case right = "right peg"
}

func getOtherPeg(_ p : Peg, _ q : Peg) -> Peg {
    var allPegs = [Peg.left, Peg.middle, Peg.right]
    allPegs.removeAll(where: { peg in peg == p} )
    allPegs.removeAll(where: { peg in peg == q} )
    return allPegs.first!
}

func printMove(from p : Peg, to q : Peg) {
    print("Move one disk from the \(p.rawValue) to the \(q.rawValue).")
}

// optional but useful helper function
// function for playing the game with different starting and finishing pegs
func hanoiHelper(numOfDisks n : Int, from s : Peg, to t: Peg) {
    //TODO: fill in code here (optional)
    if n == 0 { return }
    hanoiHelper(numOfDisks: n - 1, from: s, to: getOtherPeg(s, t))
    printMove(from: s, to: t)
    hanoiHelper(numOfDisks: n - 1, from: getOtherPeg(s, t), to: t)
}

func towersOfHanoi(_ n: Int) {
    //TODO: fill in code here
    hanoiHelper(numOfDisks: n, from: .left, to: .right)
}

towersOfHanoi(3)

func partition(_ n: Int) -> Int {
    if n < 0 { return 0 }
    func p(_ n: Int, _ m: Int) -> Int {
        if n == m { return (1 + p(n, m - 1)) }
        if m == 0 || n < 0 { return 0 }
        if n == 0 { return 1 }
        return (p(n, m - 1) + p(n - m, m))
    }
    return p(n ,n)
}
print(partition(5))

func fibItr(_ n: Int) -> Int {
    assert(n >= 0)
    var curr = 1
    var prev = 0
    for _ in 0..<n {
        (curr, prev) = (curr + prev, curr)
    }
    return curr
}

func fibRec(_ n: Int) -> Int {
    assert(n >= 0)
    if n == 0 || n == 1 { return 1 }
    return fibRec(n - 1) + fibRec(n - 2)
}
print(fibItr(50))
//print(fibRec(50))
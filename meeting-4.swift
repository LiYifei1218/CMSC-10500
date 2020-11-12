// MEETING 4 CODE

func square(_ x: Int) -> Int {
    return x * x
}

func double(_ x: Int) -> Int {
    return x + x
}

// functions as variables
var f: (Int) -> Int = square
assert(f(3) == 9)

f = double
assert(f(3) == 6)

func addThree(_ x: Int, _ y: Int, _ z: Int) -> Int {
    return x + y + z
}

var g: (Int, Int, Int) -> Int = addThree

// functions as arguments
func funcExp(_ f: (Int) -> Int, toThe k: Int, appliedTo x: Int) -> Int {
    assert(k >= 0)
    if k == 0 { return x }
    var accum = x
    for _ in 1...k {
        accum = f(accum)
    }
    return accum
}

assert(funcExp(double, toThe: 3, appliedTo: 6) == 48)

// variable written not in the body of a function
var sum = 0

func addToSum(_ x: Int) -> () {
    // available inside the body of a function
    sum += x
}

assert(sum == 0)
addToSum(3)
addToSum(5)
assert(sum == 8)

// functions as return values, capturing constants
func makeAdder(_ k: Int) -> (Int) -> Int {
    // k is a constant inside makeAdder
    func adder(x: Int) -> Int {
        return x + k
    }
    return adder
}

var addTwo = makeAdder(2)

// the contant k with value 2 gets "captured" by calling makeAdder(2)
assert(addTwo(3) == 5)

// capturing variables
func makeCounter() -> () -> Int {
    var count = 0
    func counter() -> Int {
        count += 1
        return count
    }
    return counter
}

var c = makeCounter()
assert(c() == 1)
assert(c() == 2)
assert(c() == 3)
c = makeCounter()
assert(c() == 1)
assert(c() == 2)
assert(c() == 3)

// escaping functions
func compose(_ f: @escaping (Int) -> Int, _ g: @escaping (Int) -> Int) -> (Int) -> Int {
    func composed(x: Int) -> Int {
        return f(g(x))
    }
    return composed
}

assert(compose(square, double)(3) == 36)

// currying example
func curry(_ f: @escaping (Int, Int) -> Int) -> (Int) -> (Int) -> Int {
    func curried(x: Int) -> (Int) -> Int {
        func applyAgain(y: Int) -> Int {
            return f(x, y)
        }
        return applyAgain
    }
    return curried
}

func add(_ x: Int, _ y: Int) -> Int {
    return x + y
}

assert(curry(add)(2)(3) == add(2, 3))

// func uncurry(_ f: (Int) -> (Int) -> Int) -> (Int, Int) -> Int {
//     // TODO
// }


// ARRAYS ARE STRUCTURES

// Arrays construtor
var l: Array<Int> = Array<Int>()
var l2 = [Int]()
var l3 : [Int] = []


// Array literal
l = [1, 2, 3, 4]

// Array properties (variables associated with particular objects)
assert(l.count == 4)
assert(!l.isEmpty)

// Array methods (function affecting particular objects)
l.append(5)
assert(l == [1, 2, 3, 4, 5])
assert(l.reversed() == [5, 4, 3, 2, 1])

// Array indexing
assert(l[2] == 3)

// Array indexing with ranges
assert(l[0...2] == [1, 2, 3])

// for loops with lists
// for x in l {
//     print(x)
// }

// Array are value types
var lCopy = l
lCopy.append(6)
assert(lCopy != l)

// array to matrix example
func arrayToMatrix(_ l: [Int], width: Int, height: Int) -> [[Int]] {
    assert(width > 0 && height > 0)
    assert(l.count == width * height)
    var out = [[Int]]()
    for i in 0..<height {
        var row = [Int]()
        for j in 0..<width {
             row.append(l[i * width + j])
        }
        out.append(row)
    }
    return out
}

// Optionals
var y: Optional<Int> = 2
var x: Int? = 2
x = nil

// assignment
var z = 200
x = z

// force unwrap
var q: Int = x!

// if let
if let val = x {
    print(val)
}

// while let
var i = 0
while let val = x {
    print(val)
    i += 1
    if i == 5 {
        x = nil
    }
}

// compound conditions
var b = false
if let _ = x, !b {
    print(b)
}

// dictionary construtors
var dict: Dictionary<Int, String> = Dictionary<Int, String>()
var dict2 = [Int: String]()

// dictionary literals
dict = [1: "11", 2: "22", 3: "33"]

// indexing
print(dict[1]!)
print(dict[0])

// assigning
dict[4] = "44"

assert(dict.count == 4)

// unassigning
dict[4] = nil

assert(dict.count == 3)

// iterating over dictionaries
// for key in dict.keys {
//     print(key)
// }
//
// for values in dict.values {
//     print(values)
// }
//
// for (key, values) in dict {
//     print(keys)
//     print(values)
// }

for pair in dict {
    print(pair.key)
    print(pair.value)
}

// mistake in last, can call functions above definition.
func f1(_ x: Int) -> Int {
    return f2(x)
}

func f2(_ x: Int) -> Int {
    return double(x)
}

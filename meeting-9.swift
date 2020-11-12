// BASIC STRUCTURE FOR ITERATOR

// FIRST function gets first element of the things we want to iterate over

// func first() -> ThingWeWantToIterateOver {
//
// }

// NEXT function gets the next element after the input
// returns nil if we have reached the end of the collection we are iterating over.

// func next(after x: ThingWeWantToIterateOver) -> ThingWeWantToIterateOver? {
//
// }


// WE WANT TO WRITE SOMETHING LIKE

// for pair in (1, 1)...(6, 6) {
//     print(pair)
// }

// SO THAT IT PRINTS

// (1, 1)
// (1, 2)
// (1, 3)
// ...
// (1, 6)
// (2, 1)
// ...
// (6, 5)
// (6, 6)

// INSTEAD WE WILL USE AN ITERATOR AND A WHILE LOOP

// (1, 1) <-- first()
// (1, 2) <-- next(after: (1, 1))!
// (1, 3) <-- next(after: (1, 2))!
// ...
// (1, 6) <-- next(after: (1, 5))!
// (2, 1) <-- next(after: (1, 6))!
// ...
// (6, 5) <-- next(after: (6, 4))!
// (6, 6) <-- next(after: (6, 5))!

typealias Pair = (Int, Int)

func firstOneToSixPair() -> Pair {
    return (1, 1)
}

func nextOneToSixPair(after pair: Pair) -> Pair? {
    if pair == (6, 6) { return nil }
    let firstNumber = pair.0
    let secondNumber = pair.1
    if secondNumber == 6 {
        return (firstNumber + 1, 1)
    }
    return (firstNumber, secondNumber + 1)
}

assert(nextOneToSixPair(after:(1, 3))! == (1, 4))
assert(nextOneToSixPair(after:(3, 6))! == (4, 1))
assert(nextOneToSixPair(after:(6, 6)) == nil)

var distribution = [Int: Int]()

var currentPair: (Int, Int)? = firstOneToSixPair()
while let actualPair = currentPair {
    distribution[actualPair.0 + actualPair.1] =
        // we can use nil-coalesing operator to add one to dictionary value
        (distribution[actualPair.0 + actualPair.1] ?? 0) + 1
    currentPair = nextOneToSixPair(after: actualPair)
}

// WE CAN COMPOSE ITERATORS TO CREATE MORE COMPLEX ITERATORS

func firstPairofPairs() -> (Pair, Pair) {
    return (firstOneToSixPair(), firstOneToSixPair())
}

func nextPairOfPairs(after curr: (Pair, Pair)) -> (Pair, Pair)? {
    let firstPair: Pair = curr.0
    let secondPair: Pair = curr.1
    if let next = nextOneToSixPair(after: secondPair) {
        return (firstPair, next)
    }
    if let next = nextOneToSixPair(after: firstPair) {
        return (next, firstOneToSixPair())
    }
    return nil
}

var currPairOfPairs: (Pair, Pair)? = firstPairofPairs()
while let actualPairOfPairs = currPairOfPairs {
    // do stuff with actualPairOfPairs
    currPairOfPairs = nextPairOfPairs(after: actualPairOfPairs)
}

// INSTEAD WE MIGHT WANT THIS ORDER

// (1, 1)
// (2, 1)
// (2, 2)
// (3, 1)
// (3, 2)
// (3, 3)
// (4, 1)
// (4, 2)
// (4, 3)
// (4, 4)
// (5, 1)
// ...
// (6, 5)
// (6, 6)

// WE CAN BUILD A DIFFERENT ITERATOR for Ordered Pairs

func firstOrderedPair() -> Pair {
    return (1, 1)
}

func nextOrderedPair(after p: Pair) -> Pair? {
    if p == (6, 6) { return nil }
    let firstNumber = p.0
    let secondNumber = p.1
    if secondNumber + 1 > firstNumber {
        return (firstNumber + 1, 1)
    } else {
        return (firstNumber, secondNumber + 1)
    }
}

var currOrdPair: Pair? = firstOrderedPair()
while let actual = currOrdPair {
    // do stuff with actual
    currOrdPair = nextOrderedPair(after: actual)
}

// WE CAN CREATE AN ORDERED PAIR OF ORDERED PAIRS AS WELL

func firstOrdOfOrd() -> (Pair, Pair) {
    return (firstOrderedPair(), firstOrderedPair())
}

func nextOrdOfOrd(after p: (Pair, Pair)) -> (Pair, Pair)? {
    let firstPair = p.0
    let secondPair = p.1
    if firstPair != secondPair {
        return (firstPair, nextOrderedPair(after: secondPair)!)
    }
    if let afterFirst = nextOrderedPair(after: firstPair) {
        return (afterFirst, secondPair)
    }
    return nil
}

var currOrdOfOrd: (Pair, Pair)? = firstOrdOfOrd()
while let actual = currOrdOfOrd {
    // do stuff with actual
    currOrdOfOrd = nextOrdOfOrd(after: actual)
}

// A BIT ABOUT THE APPROXIMATE CHOOSE FUNCTION

// standard factorial function
func factorial(_ n: Int) -> Int {
    assert(n >= 1)
    var accum = 1
    for i in 1...n {
        accum *= i
    }
    return accum
}

// FACTORIALS ARE QUITE LARGE
// 20 IS THE LARGEST VALUE THE COMPUTER CAN HANDLE
print(factorial(20))


// STANDARD DEFINITION FOR N CHOOSE K

//       n!
// -------------
// (n - k)! * k!

// APPROXIMATE DEFINITION FOR N CHOOSE K
// WHERE EACH FRACTION IS REPRESENTED AS A Double

// n     n - 1           n - k
//--- * ------- * ... * -------
// k     k - 1             1

// Doubles ARE NOT FULLY PRECISE
assert(10.0 == 10.00000000000000000000000000001)

// BUT THEY GET US CLOSE ENOUGHT

// WE CAN USE THIS TO APPROXIMATE THE MULTISET NUMBER
// WHICH WE CAN USE TO COUNT THE NUMBER OF POSSIBLE DICE COMBINATIONS

// mutltiset(multiset(10, 6), 2) <-- number of pairs of dice with
//                                   six sides, each side having
//                                   value between 1 and 10

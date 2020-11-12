/*
 * Author: Yifei Li
 * Date: 2020-06-29 01:13:42
 * LastEditTime: 2020-07-02 02:48:21
 * FilePath: /CS105/hw3/assignment3.swift
 */
import Foundation
func approxPiByPolygons(numbersOfSides n: Int) -> Double {
    let doubleN = Double(n)
    let inscribing = 0.5 * doubleN * sin(2 * .pi / doubleN)
    let circumscribing = doubleN * tan(.pi / doubleN) 
    let approx = (inscribing + circumscribing) / 2
    return approx
}

print(approxPiByPolygons(numbersOfSides: 2000))
// 3.1415913616641484

func fibonacci(_ k: Int) -> Int {
    if k <= 0 {return 0}
    else if k == 1 {return 1}
    else {
        return (fibonacci(k - 1) + fibonacci(k - 2))
    }
}

//print(fibonacci(3))
assert(fibonacci(-1) == 0)
assert(fibonacci(3) == 2)
assert(fibonacci(10) == 55)

func sumOfTheDigits(of num: Int) -> Int {
    var digits = abs(num)
    var sum = 0
    while digits != 0 {
        sum += digits % 10
        digits /= 10
    }
    return sum
}
//print(sumOfTheDigits(of: 123))
assert(sumOfTheDigits(of: 123) == 6)
assert(sumOfTheDigits(of: -10101) == 3)
assert(sumOfTheDigits(of: 55555) == 25)

func isPalindrome(_ n: Int) -> Bool {
    if n < 0 || (n % 10 == 0 && n != 0) { return false }
    var digits = n
    var revDigits = 0
    while digits > revDigits {
        revDigits = revDigits * 10 + digits % 10
            digits /= 10
    }
    return digits == revDigits || digits == revDigits / 10;
}

assert(!isPalindrome(12345))
assert(isPalindrome(10101))
assert(!isPalindrome(-101))
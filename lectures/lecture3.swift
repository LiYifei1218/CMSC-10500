func intToPosInt(_ x: Int, toThe y: Int) -> Int {
    assert(y >= 0, "Error: neagtive exponents")
    var ans = 1
    if y == 0 {return 1}
    for _ in 0..<y {
        ans *= x;
    }
    return ans;
}

print(intToPosInt(2, toThe: 3))

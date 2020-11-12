import Foundation

struct OrderedDictionary<S: Hashable, T> {

    // -------------------
    // DATA REPRESENTATION
    // -------------------

    // var data = [(S, T)]()

    var data1 = [S: T]()
    var data2 = [S]()

    // -------------------
    // GET-SET FUNCTIONS
    // -------------------

    // var keysAndValues: [(S, T)] {
    //     get {
    //         return data
    //     }
    // }

    // subscript(key: S) -> T? {
    //     get {
    //         for pair in data {
    //             if key == pair.0 { return pair.1 }
    //         }
    //         return nil
    //     }
    //     set(newValue) {
    //         for i in 0..<data.count {
    //             if data[i].0 == key {
    //                 if newValue != nil { data[i].1 = newValue!; return}
    //                 else { data.remove(at: i); return}
    //             }
    //         }
    //         if newValue != nil { data.append((key, newValue!)) }
    //     }
    // }

    var keysAndValues: [(S, T)] {
        get {
            var out = [(S, T)]()
            for item in data2 {
                out.append((item, data1[item]!))
            }
            return out
        }
    }

    subscript(key: S) -> T? {
        get {
            return data1[key]
        }
        set(newValue) {
            if newValue == nil {
                data1.removeValue(forKey: key)
                for i in 0..<data2.count {
                    if key == data2[i] {
                        data2.remove(at: i)
                        return
                    }
                }
            } else {
                data1[key] = newValue
                if data2.contains(key) { return }
                data2.append(key)
            }
        }
    }

    // -------------------
    // ABSTRACTION BARRIER
    // -------------------

    var isEmpty: Bool {
        get {
            if keysAndValues.isEmpty { return true }
            else { return false }
        }
    }
    var count: Int {
        get {
            return keysAndValues.count
        }
    }
    var keys: [S] {
        get {
            var out = [S]()
            for pair in keysAndValues {
                out.append(pair.0)
            }
            return out
        }
    }
    var values: [T] {
        get {
            var out = [T]()
            for pair in keysAndValues {
                out.append(pair.1)
            }
            return out
        }
    }
    func atIndex(_ i : Int) -> (key: S, value: T) {
        assert(i >= 0 && i < count, "ERROR: index out of range")
        return keysAndValues[i]
    }

    func index(forKey k : S) -> Int? {
        for i in 0..<keysAndValues.count {
            if k == keysAndValues[i].0 {
                return i
            }
        }
        return nil
    }

    mutating func removeValue(forKey key: S) -> T? {
        let oldValue = self[key]
        self[key] = nil
        return oldValue
    }

    mutating func remove(at index: Int) -> (key: S, value: T) {
        assert(index >= 0 && index < count, "ERROR: index out of range")
        let oldValue = keysAndValues[index]
        let _ = self.removeValue(forKey: keysAndValues[index].0)
        return oldValue
    }

    mutating func updateValue(_ value: T, forKey key: S) -> T? {
        if self[key] == nil { return nil }
        let oldValue = self[key]
        self[key] = value
        return oldValue
    }

    mutating func updateValue(_ value: T, atIndex index: Int) -> T? {
        assert(index >= 0 && index < count, "ERROR: index out of range")
        let oldValue = keysAndValues[index].1
        let _ = self.updateValue(value, forKey: keysAndValues[index].0)
        return oldValue
    }
}


// -----
// TESTS
// -----

var d = OrderedDictionary<Int, Int>()
print(d)
assert(d.isEmpty)
d[1] = 1
print(d)
assert(!d.isEmpty)
d[2] = 2
print(d)
assert(d.count == 2)
assert(d.keys == [1, 2])
d[1] = 3
print(d)
assert(d.values == [3, 2])
d[1] = nil
print(d)
d[1] = 1
print(d)
assert(d.atIndex(0) == (2, 2))
assert(d.index(forKey: 1) == 1)
assert(d.removeValue(forKey: 2) == 2)
print(d)
d[3] = 3
print(d)
assert(d.remove(at: 1) == (3, 3))
print(d)
assert(d.updateValue(2, forKey: 2) == nil)
print(d)
assert(d.updateValue(2, atIndex: 0) == 1)
print(d)

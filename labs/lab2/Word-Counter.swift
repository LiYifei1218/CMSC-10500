/*
 * Author: Yifei Li
 * Date: 2020-07-02 23:12:46
 * LastEditTime: 2020-07-09 00:39:22
 * FilePath: /CS105/labs/lab2/Word-Counter.swift
 */
import Foundation

func getInput() -> String {
    var out = ""
    while let s = readLine() {
        out = out + " " + s
    }
    return out + " "
}

func toWordList(_ s: String) -> [String] {
    var out = [""]
    func separateCharacter(_ c: Character) -> Bool {
        return !(c.isLetter || (c == "\'") || (c == "-"))
    }
    var word: String = ""
    for i in s.indices {
        if separateCharacter(s[i]) {
            out.append(word)
            word = ""
            continue
        }
        word += String(s[i])
    }
    return out.filter {$0 != ""}
}

func toDictionary(_ stringList: [String]) -> [String: Int] {
    var out = [String: Int]()
    for s in stringList {
        if out[s] == nil {
            out[s] = 1;
        }
        else {
            out[s]! += 1
        }
    }
    return out
}

func output(_ dict: [String: Int]) {
    let sorted = dict.sorted(by: { $0.1 > $1.1 })
    for pair in sorted {
        print(pair.key + ": " + String(pair.value))
    }
}

func main() {
    output(toDictionary(toWordList(getInput().lowercased())))
}

main()

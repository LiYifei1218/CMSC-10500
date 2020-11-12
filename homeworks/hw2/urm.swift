import Foundation

struct UnlimitedRegisterMachine {
    var registers = [Int: Int]()

    subscript(index : Int) -> Int {
        get {
            if let value = registers[index] {
                return value
            } else {
                return 0
            }
        }
        set {
            registers[index] = newValue == 0 ? nil : newValue
        }
    }

    mutating func increment(at i: Int) {
        self[i] += 1
    }

    mutating func zero(at i : Int) {
        self[i] = 0
    }

    mutating func transfer(from i: Int, to j: Int) {
        self[j] = self[i]
    }
}

struct Program {
    enum Instruction : Equatable {
        case S(Int)
        case Z(Int)
        case T(Int, Int)
        case J(Int, Int, Int)

        static func parseInstruction(_ i: String) -> Instruction? {
            var stripped = i
            stripped.removeAll(where: { $0 == " " })
            if let name = stripped.first {
                stripped.removeFirst(2)
                stripped.removeLast()
                var args: [Int] = []
                let optArgs = stripped
                    .split(separator: ",")
                    .map( { String($0) })
                    .map( { Int($0) })
                if optArgs.contains(nil) {
                    return nil
                } else {
                    args = optArgs.map({ $0! })
                }
                switch name {
                    case "S":
                        if args.count != 1 { return nil }
                        return S(args[0])
                    case "Z":
                        if args.count != 1 { return nil }
                        return Z(args[0])
                    case "T":
                        if args.count != 2 { return nil }
                        return T(args[0], args[1])
                    case "J":
                        if args.count != 3 { return nil }
                        return J(args[0], args[1], args[2])
                    default:
                        return nil
                }
            }
            return nil
        }
    }

    enum ProgramError : Error {
        case CannotFindFile
        case IllFormedInstruction(atLine: Int)
}

    let instructionList: [Instruction]
    let maxLine: Int

    init(fromFile f: String) throws {
        var contents = ""
        do {
            contents = try String(contentsOfFile: f)
        } catch {
            throw ProgramError.CannotFindFile
        }
        let optList = contents
            .split(separator: "\n")
            .map({ String($0) })
            .map(Instruction.parseInstruction)
        if optList.contains(nil) {
            throw ProgramError
                .IllFormedInstruction(atLine: optList.firstIndex(of: nil)!)
        }
        instructionList = optList.map({ $0! })
        maxLine = instructionList.count - 1
    }

    subscript(index : Int) -> Instruction {
        get {
            return instructionList[index]
        }
    }

    func run(onInputs inputs: [Int]) -> Int {
        var m = UnlimitedRegisterMachine()
        for i in 0..<inputs.count {
            m[i] = inputs[i]
        }
        var currLine = 0
        while currLine <= maxLine {
            switch self[currLine] {
                case .S(let k):
                    m.increment(at: k)
                    currLine += 1
                case .Z(let k):
                    m.zero(at: k)
                    currLine += 1
                case .T(let j, let k):
                    m.transfer(from: j, to: k)
                    currLine += 1
                case .J(let i, let j, let k):
                    currLine = m[i] == m[j] ? k : currLine + 1
            }
        }
        return m[0]
    }
}

if CommandLine.arguments.count <= 1 {
    print("USAGE: swift urm.swift <filename> <input1> <input2> ...")
    exit(1)
}

let filename = CommandLine.arguments[1]

var inputs: [Int] = []

if CommandLine.arguments.count > 2 {
    let optInputs = CommandLine.arguments[2...].map({ Int($0) })
    if optInputs.contains(nil) {
        print("ERROR: inputs must be nonnegative integers")
        exit(1)
    }
    inputs = optInputs.map({ $0! })
}
if let m = inputs.min(), m < 0 {
    print("ERROR: inputs must be nonnegative integers")
    exit(1)
}

do {
    let p = try Program(fromFile: filename)
    print(p.run(onInputs:inputs))
} catch Program.ProgramError.CannotFindFile {
    print("ERROR: cannot find file named " + filename)
    exit(1)
} catch Program.ProgramError.IllFormedInstruction(let k) {
    print("ERROR: ill-formed instruction on line " + String(k))
    exit(1)
}

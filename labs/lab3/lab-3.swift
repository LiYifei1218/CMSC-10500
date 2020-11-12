/*
 * Author: Yifei Li
 * Date: 2020-07-09 23:06:44
 * LastEditTime: 2020-07-15 03:54:25
 * FilePath: /CS105/labs/lab3/lab-3.swift
 */
import Foundation

struct Image {
    enum Pixel: Character {
        case on = "*"
        case off = " "
    }

    enum Side {
        case top
        case bottom
        case left
        case right
    }

    var grid: [[Pixel]]

    init(width: Int, height: Int) {
        assert(width > 0 && height > 0)
        grid = []
        for _ in 1...height {
            grid.append(Array(repeating: .off, count: width))
        }
    }

    init(fromString s: String) {
        grid = []
        let splt = s.split(separator: "\n")
        let height = splt.count
        var width = 0
        for line in splt {
            width = max(width, line.count)
        }
        for i in 0..<height {
            var line = [Pixel]()
            for c in splt[i] {
                if c == Pixel.off.rawValue { line.append(.off) }
                else if c == Pixel.on.rawValue { line.append(.on) }
            }
            while line.count < width { line.append(.off) }
            grid.append(line)
        }
    }

    func width() -> Int {
        return grid.first!.count
    }

    func height() -> Int {
        return grid.count
    }

    func asString() -> String {
        var str = ""
        for line in grid {
            for pixel in line {
                if pixel == .on { str += String(Pixel.on.rawValue) }
                else { str += String(Pixel.off.rawValue) }
            }
            str += "\n"
        }
        return str
    }

    mutating func stack(_ image: Image, on side: Side) {
        switch side {
            case .top:
                //assert(image.width() == grid.first!.count)
                for line in image.grid.reversed() { grid.insert(line, at: 0) }

            case .bottom:
                //assert(image.width() == grid.first!.count)
                for line in image.grid { grid.append(line) }

            case .left:
                //assert(image.width() == grid.count)
                for i in 0..<grid.count {
                    grid[i].insert(contentsOf: image.grid[i], at: 0)
                }

            case .right:
                //assert(image.width() == grid.count)
                for i in 0..<grid.count {
                    grid[i].append(contentsOf: image.grid[i])
                }
        }
    }

    mutating func trim(by amount: Int, on side: Side) {
        switch side {
            case .top:
                grid.removeSubrange(0..<amount)

            case .bottom:
                grid.removeSubrange((grid.count - amount)..<grid.count)

            case .left:
                for i in 0..<grid.count {
                    grid[i].removeSubrange(0..<amount)
                }

            case .right:
                for i in 0..<grid.count {
                    grid[i].removeSubrange((grid[i].count - amount)..<grid[i].count)
                }
        }
    }

    mutating func pad(by amount: Int, on side: Side) {
        switch side {
            case .top:
                grid.insert(contentsOf: Array(repeating: Array(repeating: Pixel.off, count: grid[0].count), count: amount), at: 0)

            case .bottom:
                grid.append(contentsOf: Array(repeating: Array(repeating: Pixel.off, count: grid[0].count), count: amount))

            case .left:
                for i in 0..<grid.count {
                    grid[i].insert(contentsOf: Array(repeating: Pixel.off, count: amount), at: 0)
                }

            case .right:
                for i in 0..<grid.count {
                    grid[i].append(contentsOf: Array(repeating: Pixel.off, count: amount))
                }
        }
    }
}

let pixel = Image(fromString: "*")

let cross = Image(fromString:
    """
     *
    ***
     *
    """
)

let x = Image(fromString:
    """
    * *
     *
    * *
    """
)

func sierpinskiRightTriangle(_ n: Int) -> Image {
    
    if n == 0 { return pixel }

    let img = Image(fromString: sierpinskiRightTriangle(n - 1).asString())
    var out = img
    out.stack(img, on: .right)
    out.stack(img, on: .top)
    return out
}

func sierpinskiCross(_ n: Int) -> Image {
    fractalImage(cross, depth: n)
}

func fractalImage(_ image: Image, depth: Int) -> Image {
    if depth == 0 { return pixel }
    if depth == 1 { return image }
    let next = fractalImage(image, depth: depth - 1)

    let blank = Image(width: image.width(), height: image.width())

    var out = Image(width: (image.width() * image.width()) + 1, height: 1)
    for line in next.grid {
        var outLine = Image(width: 1, height: image.height())
        for pixel in line {
            if pixel == .off {
                outLine.stack(blank, on: .right)
            }
            else {
                outLine.stack(image, on: .right)
            }
        }
        out.stack(outLine, on: .bottom)
    }
    out.trim(by: 1, on: .top)
    out.trim(by: 1, on: .left)
    return out
}

func x(_ n: Int) -> Image {
    fractalImage(x, depth: n)
}

// func sierpinskiTriangle(_ n: Int) -> Image {
//     if n == 0 { return pixel }
//     if n == 1 { return triangle }
//     let next = fractalImage(triangle, depth: n - 1)

//     let blank = Image(width: triangle.width(), height: triangle.width())

//     var out = Image(width: (triangle.width() * triangle.width()) + 1, height: 1)
//     for line in next.grid {
//         var outLine = Image(width: 1, height: triangle.height())
//         // var trimTriangle = triangle
//         //     trimTriangle.trim(by: 1, on: .left)
//         //     //trimTriangle.trim(by: 1, on: .right)
//         //     trimTriangle.trim(by: 1, on: .top)

//         for i in 0..<line.count {
//             if line[i] == .off {
//                 var trimBlank = blank
//                 //trimBlank.trim(by: i , on: .left)
//                 //trimBlank.trim(by: i/2, on: .right)
//                 outLine.stack(blank, on: .right)
//             }
//             else if line[i] == .on && (i == 0) {
//                 outLine.stack(triangle, on: .right)
//             }
//             else {
//                 outLine.stack(triangle, on: .right)
//             }
//         }
//         outLine.trim(by: 1, on: .top)
//         out.stack(outLine, on: .bottom)
//     }
//     out.trim(by: 1, on: .top)
//     out.trim(by: 1, on: .left)
//     return out
// }


print(sierpinskiRightTriangle(5).asString())

print(sierpinskiCross(4).asString())

print(x(4).asString())

//print(sierpinskiTriangle(3).asString())

//
// starter code for the tic tac toe terminal game
//

import Foundation


struct TicTacToeGame {
    enum Player: String {
        case x = "X"
        case o = "O"
    }

    struct Board {
        struct Position: Hashable {
            var row: Int
            var column: Int
        }

        let size: Int
        var boardState = [Position: Player]()

        init(size: Int) {
            assert(size >= 1, "Board size must be positive")
            self.size = size
        }

        var rowIndices: Range<Int> {
            get {
                return 0..<size
            }
        }

        var columnIndices: Range<Int> {
            get {
                return 0..<size
            }
        }

        subscript(row: Int, column: Int) -> Player? {
            get {
                assert(rowIndices.contains(row) && columnIndices.contains(column), "Board index out of bounds")
                return boardState[Position(row: row, column: column)]
            } set(player) {
                assert(rowIndices.contains(row) && columnIndices.contains(column), "Board index out of bounds")
                return boardState[Position(row: row, column: column)] = player
            }
        }

        subscript(position: Position) -> Player? {
            get {
                return self[position.row, position.column]
            }
            set(player) {
                self[position.row, position.column] = player
            }
        }
    }

    var size: Int
    var board: Board

    init(size: Int) {
        self.size = size
        board = Board(size: size)
    }

    var currentPlayer: Player {
        get {
            if board.boardState.count % 2 == 0 {
                return .x
            } else {
                return .o
            }
        }
    }

    var winner: Player? {
        get {
            for row in board.Rows {
                if row.allSame {
                    return row.first!
                }
            }
            for column in board.Columns {
                if column.allSame {
                    return column.first!
                }
            }
            for diagional in board.Diagonals {
                if diagional.allSame {
                    return diagional.first!
                }
            }
            return nil
        }
    }

    var isOver: Bool {
        get {
            if winner != nil || board.unoccupiedPositions.isEmpty { return true }
            else { return false }
        }
    }

    mutating func makeMove(row: Int, column: Int) {
        if board.isValidMove(row: row, column: column) {
            board[Board.Position(row: row, column: column)] = currentPlayer
        }
    }

    mutating func makeMove(at position: Board.Position) {
        if board.isValidMove(position) {
            board[position] = currentPlayer
        }
    }
}

extension TicTacToeGame.Board: CustomStringConvertible {
    var description: String {
        var out = ""
        for row in rowIndices {
            var line = ""
            for column in columnIndices {
                line += " " + (self[row, column]?.rawValue ?? " ") + " "
                line += column < size - 1 ? "|" : ""
            }
            let lineWithoutSymbols = String(line.map({ $0 == "X" || $0 == "O" ? " " : $0 }))
            let bar = String(repeating: "-", count: 4 * size - 1)
            out += "\(lineWithoutSymbols)\n\(line)\n\(lineWithoutSymbols)"
            out += row < size - 1 ? "\n" + bar + "\n" : ""
        }
        return out
    }
}

extension TicTacToeGame.Board {
    var occupiedPositions: [Position] {
        get {
            var out = [Position]()
            for pos in boardState.keys {
                out.append(pos)
            }
            return out
        }
    }
    var unoccupiedPositions: [Position] {
        get {
            var out = [Position]()
            for row in rowIndices {
                for column in columnIndices {
                    let pos = Position(row: row, column: column)
                    if boardState[pos] == nil { out.append(pos) }
                }
            }
            return out
        }
    }

    func isValidMove(row: Int, column: Int) -> Bool {
        if !rowIndices.contains(row) || !columnIndices.contains(column) { return false }
        else if self.unoccupiedPositions.contains(Position(row: row, column: column)) { return true }
        else { return false }
    }

    func isValidMove(_ position: Position) -> Bool {
        return isValidMove(row: position.row, column: position.column)
    }

    var Rows: [[TicTacToeGame.Player?]] {
        get {
            var out = [[TicTacToeGame.Player?]]()
            for row in rowIndices {
                var rowOut = [TicTacToeGame.Player?]()
                for column in columnIndices {
                    let pos = Position(row: row, column: column)
                    if boardState[pos] == nil{
                        rowOut.append(nil)
                    } else {
                        rowOut.append(boardState[pos])
                    }
                }
                out.append(rowOut)
            }
            return out
        }
    }

    var Columns: [[TicTacToeGame.Player?]] {
        get {
            var out = [[TicTacToeGame.Player?]]()
            for column in columnIndices {
                var columnOut = [TicTacToeGame.Player?]()
                for row in rowIndices {
                    let pos = Position(row: row, column: column)
                    if boardState[pos] == nil{
                        columnOut.append(nil)
                    } else {
                        columnOut.append(boardState[pos])
                    }
                }
                out.append(columnOut)
            }
            return out
        }
    }

    var Diagonals: [[TicTacToeGame.Player?]] {
        get {
            var out = [[TicTacToeGame.Player?]]()
            var diagonalOut = [TicTacToeGame.Player?]()
            for index in rowIndices {
                let pos = Position(row: index, column: index)
                    if boardState[pos] == nil{
                        diagonalOut.append(nil)
                    } else {
                        diagonalOut.append(boardState[pos])
                }
            }
            out.append(diagonalOut)
            diagonalOut = [TicTacToeGame.Player?]()
            for index in rowIndices {
                let pos = Position(row: index, column: 2 - index)
                    if boardState[pos] == nil{
                        diagonalOut.append(nil)
                    } else {
                        diagonalOut.append(boardState[pos])
                }
            }
            out.append(diagonalOut)
            return out
        }
    }

    func numOfNInLine(_ n: Int) -> Int {
        var out = 0
        var counts = [0: 0, 1: 0]
        for row in self.Rows {
            row.forEach { P in if P == .x { counts[0]! += 1 }
                               else { counts[1]! += 1 } }
        }
        for occ in counts.values { out += (occ == n ? 1 : 0) }

        counts = [0: 0, 1: 0]
        for column in self.Columns {
            column.forEach { P in if P == .x { counts[0]! += 1 }
                               else { counts[1]! += 1 } }
        }
        for occ in counts.values { out += (occ == n ? 1 : 0) }

        counts = [0: 0, 1: 0]
        for diagional in self.Diagonals {
            diagional.forEach { P in if P == .x { counts[0]! += 1 }
                               else { counts[1]! += 1 } }
        }
        for occ in counts.values { out += (occ == n ? 1 : 0) }
        return out
    }
}

extension Array where Element : Equatable {
    var allSame: Bool {
        if let firstElem = first {
            return !dropFirst().contains { $0 != firstElem }
        }
        return true
    }
}



// ------------------------------
// COMPUTER PLAYER IMPLEMENTATION
// ------------------------------

extension TicTacToeGame {

    mutating func makeComputerMove() {
        func minimax(of game: TicTacToeGame) -> Double {
            // TODO : returns the minimax value of a given game
            // OUTLINE OF PROCEDURE
            // value of game with X as winner is 1.0
            if game.winner == .x { return 1.0 }
            // value of game with O as winner is -1.0
            if game.winner == .o { return -1.0 }
            // value of draw is 0.0
            if game.isOver { return 0.0 }
            var maximum = -Double.greatestFiniteMagnitude
            var minimum = Double.greatestFiniteMagnitude
            for unoccupied in game.board.unoccupiedPositions {
                var copy = game
                copy.makeMove(at: unoccupied)
                let MM = minimax(of: copy)
                maximum = max(MM, maximum)
                minimum = min(MM, minimum)
            }
            switch game.currentPlayer {
                case .x: 
                    return maximum
                case .o: 
                    return minimum
            }
        }
        if !isOver {
            var MM = [Double]()
            for unoccupied in self.board.unoccupiedPositions {
                var copy = self
                copy.makeMove(at: unoccupied)
                MM.append(minimax(of: copy))
            }
            makeMove(at: self.board.unoccupiedPositions[MM.firstIndex(of: MM.min()!)!])
        }
    }

    func heuristicValue(of game:TicTacToeGame) -> Double {
        // (EXTRA CREDIT) returns a heuristic value of the game state
        return 0.0
    }

    mutating func makeComputerMove(depth: Int) {
        // (EXTRA CREDIT) same as above, but with a depth limit
        var currDepth = 0
        func minimax(of game: TicTacToeGame) -> Double {
            if game.winner == .x { return 1.0 }
            if game.winner == .o { return -1.0 }
            if game.isOver { return 0.0 }
            var maximum = -Double.greatestFiniteMagnitude
            var minimum = Double.greatestFiniteMagnitude
            for unoccupied in game.board.unoccupiedPositions {
                var copy = game
                copy.makeMove(at: unoccupied)
                let MM = minimax(of: copy)
                maximum = max(MM, maximum)
                minimum = min(MM, minimum)
            }
            if currDepth <= depth {
                currDepth += 1
                switch game.currentPlayer {
                    case .x: 
                        return maximum
                    case .o: 
                        return minimum
                }
            }
            return heuristicValue(of: game)
        }
        if !isOver {
            var MM = [Double]()
            for unoccupied in self.board.unoccupiedPositions {
                var copy = self
                copy.makeMove(at: unoccupied)
                MM.append(minimax(of: copy))
            }
            makeMove(at: self.board.unoccupiedPositions[MM.firstIndex(of: MM.min()!)!])
        }
    }
}

let header =
"""
WELCOME TO TERMINAL
 _______ _        _______           _______
|__   __(_)      |__   __|         |__   __|
   | |   _  ___     | | __ _  ___     | | ___   ___
   | |  | |/ __|    | |/ _` |/ __|    | |/ _ \\_/ _ \\
   | |  | | (__     | | (_| | (__     | | (_) |  __/
   |_|  |_|\\___|    |_|\\__,_|\\___|    |_|\\___/ \\___|

To make a move, type two Ints separated by space. The
first is the index of the row and the second is the
index of the column. So the input

0 0

place a piece at the top lefthand corner.
"""

func main() {
    let display : (CustomStringConvertible) -> () = {
        print("")
        print($0)
    }
    display(header)
    var game = TicTacToeGame(size: 3)
    while !game.isOver {
        switch game.currentPlayer {
        case .x:
            display(game.board)
            display("Your move...")
            while true {
                if
                    let inputs = readLine()?.split(separator: " "),
                    inputs.count == 2,
                    let row = Int(inputs[0]),
                    let column = Int(inputs[1]),
                    game.board.rowIndices.contains(row),
                    game.board.columnIndices.contains(column) {
                    if game.board.isValidMove(row: row, column: column) {
                        print(game.board.numOfNInLine(3))
                        game.makeMove(row: row, column: column)
                        print(game.board.numOfNInLine(3))
                        break
                    } else {
                        display(game.board)
                        display("That position is already taken. Try again...")
                    }
                } else {
                    display(game.board)
                    display("That is not a valid input. Try again...")
                }
            }
        case .o:
            display("The computer's move...")
            game.makeComputerMove()
            //game.makeComputerMove(depth: 5)
        }
    }
    display(game.board)
    if let player = game.winner {
        display("\(player.rawValue) player won!")
    } else {
        display("It's a draw.")
    }
}

// UNCOMMENT TO RUN COMMAND-LINE GAME
main()

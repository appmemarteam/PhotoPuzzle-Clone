import Foundation

struct PuzzleTile: Identifiable, Equatable {
    let id = UUID()
    let correctIndex: Int
    var currentIndex: Int
    var isEmpty: Bool { correctIndex == -1 }
}

struct PuzzleState {
    var tiles: [PuzzleTile]
    let size: Int
}

final class PuzzleEngine {
    static func make(size: Int) -> PuzzleState {
        let count = size * size
        var tiles: [PuzzleTile] = (0..<(count - 1)).map { i in
            PuzzleTile(correctIndex: i, currentIndex: i)
        }
        tiles.append(PuzzleTile(correctIndex: -1, currentIndex: count - 1)) // empty

        var state = PuzzleState(tiles: tiles, size: size)
        state = shuffleSolvable(state)
        return state
    }

    static func isSolved(_ state: PuzzleState) -> Bool {
        state.tiles.allSatisfy { $0.isEmpty || $0.correctIndex == $0.currentIndex }
    }

    static func canMove(_ state: PuzzleState, tile: PuzzleTile) -> Bool {
        guard let empty = state.tiles.first(where: { $0.isEmpty }) else { return false }
        let size = state.size
        let tileRow = tile.currentIndex / size
        let tileCol = tile.currentIndex % size
        let emptyRow = empty.currentIndex / size
        let emptyCol = empty.currentIndex % size
        return (abs(tileRow - emptyRow) + abs(tileCol - emptyCol)) == 1
    }

    static func move(_ state: PuzzleState, tile: PuzzleTile) -> PuzzleState {
        guard canMove(state, tile: tile),
              let emptyIndex = state.tiles.firstIndex(where: { $0.isEmpty }),
              let tileIndex = state.tiles.firstIndex(of: tile) else { return state }

        var tiles = state.tiles
        let emptyCurrent = tiles[emptyIndex].currentIndex
        tiles[emptyIndex].currentIndex = tiles[tileIndex].currentIndex
        tiles[tileIndex].currentIndex = emptyCurrent
        return PuzzleState(tiles: tiles, size: state.size)
    }

    private static func shuffleSolvable(_ state: PuzzleState) -> PuzzleState {
        let size = state.size
        let count = size * size

        var indices = Array(0..<count)
        repeat {
            indices.shuffle()
        } while !isSolvable(indices: indices, size: size)

        var tiles = state.tiles
        for i in 0..<count {
            if let tileIndex = tiles.firstIndex(where: { $0.correctIndex == indices[i] }) {
                tiles[tileIndex].currentIndex = i
            }
        }
        return PuzzleState(tiles: tiles, size: size)
    }

    private static func isSolvable(indices: [Int], size: Int) -> Bool {
        let arr = indices.filter { $0 != -1 }
        var inversions = 0
        for i in 0..<arr.count {
            for j in (i+1)..<arr.count {
                if arr[i] > arr[j] { inversions += 1 }
            }
        }

        if size % 2 == 1 { return inversions % 2 == 0 }
        let emptyIndex = indices.firstIndex(of: -1) ?? (size * size - 1)
        let emptyRowFromBottom = size - (emptyIndex / size)
        if emptyRowFromBottom % 2 == 0 {
            return inversions % 2 == 1
        } else {
            return inversions % 2 == 0
        }
    }
}

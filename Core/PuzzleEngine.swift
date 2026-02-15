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
        return PuzzleState(tiles: tiles.shuffled(), size: size)
    }

    static func isSolved(_ state: PuzzleState) -> Bool {
        state.tiles.allSatisfy { $0.isEmpty || $0.correctIndex == $0.currentIndex }
    }
}

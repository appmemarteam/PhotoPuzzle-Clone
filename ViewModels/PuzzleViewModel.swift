import Foundation
import Observation

@Observable
final class PuzzleViewModel {
    var state: PuzzleState = PuzzleEngine.make(size: 3)
    var moves: Int = 0
    var isSolved: Bool = false

    func newPuzzle(size: Int) {
        state = PuzzleEngine.make(size: size)
        moves = 0
        isSolved = false
    }

    func move(tile: PuzzleTile) {
        guard PuzzleEngine.canMove(state, tile: tile) else { return }
        state = PuzzleEngine.move(state, tile: tile)
        moves += 1
        isSolved = PuzzleEngine.isSolved(state)
    }
}

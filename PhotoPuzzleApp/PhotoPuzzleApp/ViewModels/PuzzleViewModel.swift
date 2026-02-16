import Foundation
import Observation
import Photos
import UIKit

@Observable
final class PuzzleViewModel {
    var state: PuzzleState = PuzzleEngine.make(size: 3)
    var moves: Int = 0
    var isSolved: Bool = false
    var selectedPhoto: PHAsset?
    var puzzleSize: Int = 3
    var startTime: Date?
    var solveTime: TimeInterval = 0
    
    func newPuzzle(size: Int) {
        self.puzzleSize = size
        state = PuzzleEngine.make(size: size)
        moves = 0
        isSolved = false
        startTime = Date()
    }

    func move(tile: PuzzleTile) {
        guard PuzzleEngine.canMove(state, tile: tile) else { 
            if SettingsStore.shared.hapticsEnabled {
                HapticManager.shared.notification(type: .error)
            }
            return 
        }
        
        state = PuzzleEngine.move(state, tile: tile)
        moves += 1
        
        if SettingsStore.shared.hapticsEnabled {
            HapticManager.shared.impact(style: .light)
        }
        
        if PuzzleEngine.isSolved(state) {
            isSolved = true
            if let start = startTime {
                solveTime = Date().timeIntervalSince(start)
                GameCenterManager.shared.recordSolve(moves: moves, time: solveTime)
                if SettingsStore.shared.hapticsEnabled {
                    HapticManager.shared.notification(type: .success)
                }
            }
        }
    }
}

import Foundation

struct PuzzleStats: Codable {
    var totalSolves: Int = 0
    var bestTime: TimeInterval?
    var bestMoves: Int?
    var currentStreak: Int = 0
    var lastSolveDate: Date?
}

@Observable
final class GameCenterManager {
    static let shared = GameCenterManager()
    var stats = PuzzleStats()
    
    private let statsKey = "com.appmemarteam.photopuzzle.stats"
    
    init() {
        loadStats()
    }
    
    func recordSolve(moves: Int, time: TimeInterval) {
        stats.totalSolves += 1
        
        if stats.bestMoves == nil || moves < stats.bestMoves! {
            stats.bestMoves = moves
        }
        
        if stats.bestTime == nil || time < stats.bestTime! {
            stats.bestTime = time
        }
        
        updateStreak()
        saveStats()
    }
    
    private func updateStreak() {
        let now = Date()
        guard let lastDate = stats.lastSolveDate else {
            stats.currentStreak = 1
            stats.lastSolveDate = now
            return
        }
        
        let calendar = Calendar.current
        if calendar.isDateInYesterday(lastDate) {
            stats.currentStreak += 1
        } else if !calendar.isDateInToday(lastDate) {
            stats.currentStreak = 1
        }
        stats.lastSolveDate = now
    }
    
    private func saveStats() {
        if let encoded = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(encoded, forKey: statsKey)
        }
    }
    
    private func loadStats() {
        if let data = UserDefaults.standard.data(forKey: statsKey),
           let decoded = try? JSONDecoder().decode(PuzzleStats.self, from: data) {
            stats = decoded
        }
    }
}

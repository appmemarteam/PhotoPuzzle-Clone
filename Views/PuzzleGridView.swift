import SwiftUI

struct PuzzleGridView: View {
    let state: PuzzleState
    let onTapTile: (PuzzleTile) -> Void

    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: state.size)
        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(state.tiles.sorted(by: { $0.currentIndex < $1.currentIndex })) { tile in
                ZStack {
                    if tile.isEmpty {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.clear)
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue.opacity(0.8))
                        Text("\(tile.correctIndex + 1)")
                            .foregroundStyle(.white)
                            .bold()
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .onTapGesture { onTapTile(tile) }
            }
        }
    }
}

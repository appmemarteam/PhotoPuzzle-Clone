import SwiftUI

struct PuzzleGridView: View {
    let state: PuzzleState

    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: state.size)
        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(state.tiles) { tile in
                ZStack {
                    if tile.isEmpty {
                        Color.clear
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue.opacity(0.8))
                        Text("\(tile.correctIndex + 1)")
                            .foregroundStyle(.white)
                            .bold()
                    }
                }
                .aspectRatio(1, contentMode: .fit)
            }
        }
    }
}

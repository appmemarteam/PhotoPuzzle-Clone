import SwiftUI

struct ContentView: View {
    @State private var viewModel = PuzzleViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Photo Puzzle+")
                    .font(.largeTitle.bold())

                PuzzleGridView(state: viewModel.state) { tile in
                    viewModel.move(tile: tile)
                }
                .frame(width: 300, height: 300)

                Text("Moves: \(viewModel.moves)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Button("New Puzzle") {
                    viewModel.newPuzzle(size: 3)
                }
                .buttonStyle(.borderedProminent)

                if viewModel.isSolved {
                    Text("Solved! 🎉")
                        .font(.headline)
                }
            }
            .padding()
            .navigationTitle("Puzzle")
        }
    }
}

#Preview {
    ContentView()
}

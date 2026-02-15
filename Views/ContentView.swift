import SwiftUI

struct ContentView: View {
    @State private var viewModel = PuzzleViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Photo Puzzle+")
                    .font(.largeTitle.bold())

                PuzzleGridView(state: viewModel.state)
                    .frame(width: 300, height: 300)

                Button("New Puzzle") {
                    viewModel.newPuzzle(size: 3)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Puzzle")
        }
    }
}

#Preview {
    ContentView()
}

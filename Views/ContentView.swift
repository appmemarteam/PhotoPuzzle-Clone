import SwiftUI

struct ContentView: View {
    @State private var viewModel = PuzzleViewModel()
    @State private var showingPicker = false
    @State private var uiImage: UIImage?

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack {
                    Text("Photo Puzzle+")
                        .font(.largeTitle.bold())
                    Spacer()
                    Button {
                        showingPicker = true
                    } label: {
                        Image(systemName: "photo.on.rectangle")
                            .font(.title2)
                    }
                }
                .padding(.horizontal)

                Picker("Difficulty", selection: $viewModel.puzzleSize) {
                    Text("3x3").tag(3)
                    Text("4x4").tag(4)
                    Text("5x5").tag(5)
                }
                .pickerStyle(.segmented)
                .onChange(of: viewModel.puzzleSize) { _, newValue in
                    viewModel.newPuzzle(size: newValue)
                }
                .padding(.horizontal)

                PuzzleGridView(state: viewModel.state, image: uiImage) { tile in
                    viewModel.move(tile: tile)
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .padding()

                Text("Moves: \(viewModel.moves)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Button("Shuffle") {
                    viewModel.newPuzzle(size: viewModel.puzzleSize)
                }
                .buttonStyle(.bordered)

                if viewModel.isSolved {
                    Text("Solved! 🎉")
                        .font(.headline)
                        .foregroundStyle(.green)
                }
            }
            .navigationTitle("Puzzle")
            .sheet(isPresented: $showingPicker) {
                PhotoPickerView(selectedAsset: $viewModel.selectedPhoto)
            }
            .onChange(of: viewModel.selectedPhoto) { _, newAsset in
                if let asset = newAsset {
                    loadUIImage(from: asset)
                }
            }
        }
    }
    
    private func loadUIImage(from asset: PHAsset) {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        manager.requestImage(for: asset, targetSize: CGSize(width: 1000, height: 1000), contentMode: .aspectFill, options: options) { result, _ in
            self.uiImage = result
            viewModel.newPuzzle(size: viewModel.puzzleSize)
        }
    }
}

#Preview {
    ContentView()
}

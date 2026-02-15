import SwiftUI

struct ContentView: View {
    @State private var viewModel = PuzzleViewModel()
    @State private var showingPicker = false
    @State private var showingSettings = false
    @State private var showingWinSheet = false
    @State private var uiImage: UIImage?
    @State private var showNumbers = true

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Header Area
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Moves")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(viewModel.moves)")
                                .font(.title2.bold())
                                .monospacedDigit()
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Streak")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(GameCenterManager.shared.stats.currentStreak)d")
                                .font(.title2.bold())
                        }
                    }
                    .padding(.horizontal)

                    // Difficulty & Numbers Toggle
                    HStack {
                        Picker("Difficulty", selection: $viewModel.puzzleSize) {
                            Text("3x3").tag(3)
                            Text("4x4").tag(4)
                            Text("5x5").tag(5)
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: viewModel.puzzleSize) { _, newValue in
                            viewModel.newPuzzle(size: newValue)
                        }
                        
                        Button {
                            showNumbers.toggle()
                        } label: {
                            Image(systemName: showNumbers ? "number.circle.fill" : "number.circle")
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal)

                    // The Puzzle Grid
                    PuzzleGridView(state: viewModel.state, image: uiImage, showNumbers: showNumbers) { tile in
                        viewModel.move(tile: tile)
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1, contentMode: .fit)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .black.opacity(0.05), radius: 10)
                    .padding(.horizontal)

                    Spacer()

                    // Bottom Controls
                    HStack(spacing: 20) {
                        Button {
                            showingPicker = true
                        } label: {
                            Label("Change Photo", systemImage: "photo")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        
                        Button {
                            withAnimation {
                                viewModel.newPuzzle(size: viewModel.puzzleSize)
                            }
                        } label: {
                            Label("Reshuffle", systemImage: "shuffle")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationTitle("Photo Puzzle+")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingPicker) {
                PhotoPickerView(selectedAsset: $viewModel.selectedPhoto)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingWinSheet) {
                WinView(moves: viewModel.moves, time: viewModel.solveTime) {
                    viewModel.newPuzzle(size: viewModel.puzzleSize)
                }
            }
            .onChange(of: viewModel.selectedPhoto) { _, newAsset in
                if let asset = newAsset {
                    loadUIImage(from: asset)
                }
            }
            .onChange(of: viewModel.isSolved) { _, newValue in
                if newValue {
                    showingWinSheet = true
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

struct WinView: View {
    let moves: Int
    let time: TimeInterval
    let onPlayAgain: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            Text("🎉 Solved!")
                .font(.system(size: 48, weight: .black))
            
            VStack(spacing: 8) {
                Text("\(moves) moves")
                    .font(.title2.bold())
                Text(String(format: "%.1f seconds", time))
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            
            Button {
                onPlayAgain()
                dismiss()
            } label: {
                Text("Play Again")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.top)
        }
        .padding(40)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    ContentView()
}

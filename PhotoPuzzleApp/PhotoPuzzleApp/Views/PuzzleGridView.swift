import SwiftUI

struct PuzzleGridView: View {
    let state: PuzzleState
    let image: UIImage?
    let showNumbers: Bool
    let onTapTile: (PuzzleTile) -> Void

    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: state.size)
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(state.tiles.sorted(by: { $0.currentIndex < $1.currentIndex })) { tile in
                ZStack {
                    if tile.isEmpty {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.secondary.opacity(0.1))
                    } else {
                        if let image = image {
                            ZStack(alignment: .bottomTrailing) {
                                PuzzleTileImage(image: image, tile: tile, size: state.size)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                
                                if showNumbers {
                                    Text("\(tile.correctIndex + 1)")
                                        .font(.caption2.bold())
                                        .foregroundStyle(.white)
                                        .padding(4)
                                        .background(.black.opacity(0.4))
                                        .clipShape(Circle())
                                        .padding(4)
                                }
                            }
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.accentColor.gradient)
                                .shadow(radius: 2)
                            Text("\(tile.correctIndex + 1)")
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                        }
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .onTapGesture { 
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        onTapTile(tile)
                    }
                }
            }
        }
        .padding(4)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.secondary.opacity(0.1)))
    }
}

struct PuzzleTileImage: View {
    let image: UIImage
    let tile: PuzzleTile
    let size: Int
    
    var body: some View {
        GeometryReader { geo in
            let row = CGFloat(tile.correctIndex / size)
            let col = CGFloat(tile.correctIndex % size)
            let scale = CGFloat(size)
            
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .scaleEffect(scale, anchor: UnitPoint(x: col / (scale - 1), y: row / (scale - 1)))
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
    }
}

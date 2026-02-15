import SwiftUI

struct PuzzleGridView: View {
    let state: PuzzleState
    let image: UIImage?
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
                        if let image = image {
                            PuzzleTileImage(image: image, tile: tile, size: state.size)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue.opacity(0.8))
                            Text("\(tile.correctIndex + 1)")
                                .foregroundStyle(.white)
                                .bold()
                        }
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .onTapGesture { onTapTile(tile) }
            }
        }
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

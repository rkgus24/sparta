import SwiftUI

struct EntryCardView: View {
    let entry: Entry
    let index: Int
    var onDelete: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)

                Text("Day\(String(format: "%02d", index + 1))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            if let uiImage = entry.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipped()
                    .cornerRadius(8)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)
            }
            Button(action: {
                onDelete()
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .padding(.leading, 10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

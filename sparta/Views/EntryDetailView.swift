import SwiftUI

struct EntryDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let entry: Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(entry.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            if let uiImage = entry.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
            }

            Text(entry.content)
                .font(.body)
                .foregroundColor(.white)

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("뒤로")
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .background(Color("dark900").ignoresSafeArea())
    }
}

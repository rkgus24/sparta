import SwiftUI

struct EntryDetailView: View {
    let entry: Entry

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Text(entry.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if let image = entry.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .padding(.vertical)
                }
                
                Text(entry.content)
                    .font(.body)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()
            }
            .padding()
        }
        .background(Color.dark900.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
}

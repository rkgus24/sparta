import SwiftUI
import PhotosUI

struct EntryPopupView: View {
    @Binding var inputTitle: String
    @Binding var inputContent: String
    @Binding var selectedPhoto: PhotosPickerItem?
    @Binding var selectedUIImage: UIImage?
    let onCancel: () -> Void
    let onSave: () -> Void
    
    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                TextField("", text: $inputTitle, prompt: Text("제목").foregroundColor(.white))
                    .padding(.horizontal, 12)
                    .frame(width: 300, height: 32)
                    .background(Color("dark900"))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                
                if selectedUIImage == nil {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        HStack {
                            Text("이미지 선택")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                            Spacer()
                            Image(systemName: "photo")
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 7)
                        .padding(.horizontal, 12)
                        .background(Color("dark900"))
                        .cornerRadius(8)
                    }
                    .frame(width: 300)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 8).fill(Color("dark900"))
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            if let image = selectedUIImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(10)
                            }
                            ZStack(alignment: .topLeading) {
                                if inputContent.isEmpty {
                                    Text("내용 입력...")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                        .padding(.top, 8)
                                        .padding(.horizontal, 5)
                                }
                                TextEditor(text: $inputContent)
                                    .frame(height: 300)
                                    .foregroundColor(.white)
                                    .scrollContentBackground(.hidden)
                                    .padding(.horizontal, 5)
                                    .font(.system(size: 14))
                            }
                        }
                        .padding(12)
                    }
                }
                .frame(width: 300, height: 400)
                HStack {
                    Button("취소", action: onCancel)
                        .foregroundColor(.red)
                    Spacer()
                    Button("저장", action: onSave)
                        .foregroundColor(.blue)
                }
                .frame(width: 300)
            }
            .padding()
            .background(Color("gray900"))
            .cornerRadius(12)
            .padding(.horizontal, 40)
        }
        .onChange(of: selectedPhoto) { newItem in
            if let newItem = newItem {
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedUIImage = uiImage
                    }
                }
            }
        }
    }
}

#Preview {
    EntryPopupView(inputTitle: .constant(""), inputContent: .constant(""), selectedPhoto: .constant(nil), selectedUIImage: .constant(nil), onCancel: {}, onSave: {})
}

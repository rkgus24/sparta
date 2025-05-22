import SwiftUI
import PhotosUI

struct ThirdView: View {
    @State private var showPopup = false
    @State private var entries: [Entry] = []
    
    @State private var inputTitle = ""
    @State private var inputContent = ""
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var selectedUIImage: UIImage? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.dark900.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        if entries.isEmpty {
                            Spacer()
                            Text("아직 항목이 없습니다.")
                                .foregroundColor(.gray)
                                .padding(.top, 120)
                            Spacer()
                        } else {
                            ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                                NavigationLink(destination: EntryDetailView(entry: entry)) {
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
                                        
                                        if let image = entry.image {
                                            Image(uiImage: image)
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
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    .padding(.top, 20)
                }
                
                if showPopup {
                    Color.black.opacity(0.5).ignoresSafeArea()
                    
                    VStack(spacing: 15) {
                        TextField("제목", text: $inputTitle)
                            .padding(.horizontal, 12)
                            .frame(width: 260, height: 32)
                            .background(Color.dark900)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                        
                        if selectedUIImage == nil {
                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                HStack {
                                    Text("이미지 선택")
                                        .foregroundColor(.white.opacity(0.7))
                                    Spacer()
                                    Image(systemName: "photo")
                                        .foregroundColor(.white)
                                }
                                .padding(.vertical, 7)
                                .padding(.horizontal, 12)
                                .background(Color.dark900)
                                .cornerRadius(8)
                            }
                            .frame(width: 260)
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.dark900)
                            
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
                                                .foregroundColor(.white.opacity(0.5))
                                                .padding(.top, 8)
                                                .padding(.horizontal, 5)
                                        }
                                        TextEditor(text: $inputContent)
                                            .frame(height: 300)
                                            .foregroundColor(.white)
                                            .scrollContentBackground(.hidden)
                                            .padding(.horizontal, 5)
                                    }
                                }
                                .padding(12)
                            }
                        }
                        .frame(width: 260, height: 350)
                        
                        HStack {
                            Button("취소") {
                                showPopup = false
                                clearInputs()
                            }
                            .foregroundColor(.red)
                            
                            Spacer()
                            
                            Button("저장") {
                                let newEntry = Entry(id: UUID(), title: inputTitle, image: selectedUIImage, content: inputContent)
                                entries.append(newEntry)
                                saveEntries()
                                showPopup = false
                                clearInputs()
                            }
                            .foregroundColor(.blue)
                        }
                        .frame(width: 260)
                    }
                    .padding()
                    .background(Color.gray900)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
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
            .onAppear {
                loadEntries()
            }
            .toolbar {
                if !showPopup {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image("sparta_logo")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .padding(.leading, 20)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showPopup = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.red)
                                .padding(.trailing, 20)
                        }
                    }
                }
            }
        }
    }
    private func saveEntries() {
        let entryDataArray = entries.map { entry in
            EntryData(
                id: entry.id,
                title: entry.title,
                imageData: entry.image?.jpegData(compressionQuality: 0.8),
                content: entry.content
            )
        }
        if let data = try? JSONEncoder().encode(entryDataArray) {
            UserDefaults.standard.set(data, forKey: "entries")
        }
    }
    
    private func loadEntries() {
        guard let data = UserDefaults.standard.data(forKey: "entries"),
              let savedEntries = try? JSONDecoder().decode([EntryData].self, from: data) else {
            return
        }
        
        entries = savedEntries.map { item in
            Entry(
                id: item.id,
                title: item.title,
                image: item.imageData.flatMap { UIImage(data: $0) },
                content: item.content
            )
        }
    }
    
    private func clearInputs() {
        inputTitle = ""
        inputContent = ""
        selectedPhoto = nil
        selectedUIImage = nil
    }
}

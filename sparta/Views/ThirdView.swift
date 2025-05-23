import SwiftUI
import PhotosUI

struct ThirdView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showPopup = false
    @State private var entries: [Entry] = []
    @State private var inputTitle = ""
    @State private var inputContent = ""
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var selectedUIImage: UIImage? = nil

    var body: some View {
        ZStack {
            Color("dark900").ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Image("sparta_logo")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .padding(.leading, 20)
                    Spacer()
                    Button(action: {
                        showPopup = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 32, height: 32)
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .bold))
                        }
                    }
                    .padding(.trailing, 20)
                }
                .frame(height: 60)
                .background(Color("dark900"))

                Spacer().frame(height: 20)

                ScrollView {
                    if entries.isEmpty {
                        VStack {
                            Spacer(minLength: 0)
                            Text("아직 항목이 없습니다.")
                                .foregroundColor(.gray)
                            Spacer(minLength: 0)
                        }
                        .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.6)
                    } else {
                        VStack(spacing: 20) {
                            ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                                NavigationLink(destination: EntryDetailView(entry: entry)) {
                                    EntryCardView(entry: entry, index: index) {
                                        entries.removeAll { $0.id == entry.id }
                                        saveEntries()
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                }
            }

            if showPopup {
                EntryPopupView(
                    inputTitle: $inputTitle,
                    inputContent: $inputContent,
                    selectedPhoto: $selectedPhoto,
                    selectedUIImage: $selectedUIImage,
                    onCancel: {
                        showPopup = false
                        clearInputs()
                    },
                    onSave: {
                        let newEntry = Entry(
                            id: UUID(),
                            title: inputTitle,
                            content: inputContent,
                            imageData: selectedUIImage?.jpegData(compressionQuality: 0.8)
                        )
                        entries.append(newEntry)
                        saveEntries()
                        showPopup = false
                        clearInputs()
                    }
                )
                .frame(maxWidth: 300)
                .padding()
                .background(Color("dark800"))
                .cornerRadius(12)
                .shadow(radius: 10)
            }
        }
        .onAppear(perform: loadEntries)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    dismiss()
                }
            }
        }
    }

    private func saveEntries() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: "entries")
        }
    }

    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: "entries"),
           let savedEntries = try? JSONDecoder().decode([Entry].self, from: data) {
            entries = savedEntries
        }
    }

    private func clearInputs() {
        inputTitle = ""
        inputContent = ""
        selectedPhoto = nil
        selectedUIImage = nil
    }
}

import SwiftUI
import PhotosUI

struct EntryPopupView: View {
    @Binding var isPresented: Bool
    @Binding var inputTitle: String
    @Binding var inputContent: String
    @Binding var selectedUIImage: UIImage?
    @Binding var selectedPhoto: PhotosPickerItem?
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        Text("Entry Popup View")
    }
}

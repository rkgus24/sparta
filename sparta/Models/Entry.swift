import SwiftUI

struct Entry: Identifiable {
    let id = UUID()
    let title: String
    let image: UIImage?
    let content: String
}

struct EntryData: Codable {
    let id: UUID
    let title: String
    let imageData: Data?
    let content: String
}

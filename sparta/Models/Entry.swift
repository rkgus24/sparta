import SwiftUI

struct Entry: Identifiable, Codable {
    let id: UUID
    let title: String
    let content: String
    var imageData: Data?

    var image: UIImage? {
        get {
            guard let data = imageData else { return nil }
            return UIImage(data: data)
        }
        set {
            imageData = newValue?.jpegData(compressionQuality: 0.8)
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, title, content, imageData
    }
}

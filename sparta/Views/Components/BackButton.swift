import SwiftUI

struct BackButton: View {
    var label: String = "뒤로"
    var color: Color = .white
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "chevron.left")
                Text(label)
            }
            .foregroundColor(color)
        }
    }
}

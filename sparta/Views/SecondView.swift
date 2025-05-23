import SwiftUI

struct SecondView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                BackButton {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.leading, 20)
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: ThirdView()) {
                    Text("다음  👉🏻")
                        .frame(width: 100, height: 50)
                        .background(Color.main900)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.system(size: 16, weight: .bold))
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                .padding(.horizontal, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("background_photo")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.5)
        )
        .navigationBarBackButtonHidden(true)
    }
}

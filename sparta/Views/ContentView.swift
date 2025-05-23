import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.dark900.ignoresSafeArea()

                VStack(spacing: 0) {
                    HStack {
                        Image("sparta_logo")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    .frame(height: 80)

                    Spacer()

                    VStack(spacing: 20) {
                        Image("mainChar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 118)

                        NavigationLink(destination: SecondView()) {
                            Text("내일배움캠프를 시작하며")
                                .frame(width: 190, height: 50)
                                .background(Color.main900)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .font(.system(size: 16, weight: .bold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 100)

                    Spacer() 
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}

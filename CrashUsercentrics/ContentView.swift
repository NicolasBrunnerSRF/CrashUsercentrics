import SwiftUI

struct ContentView: View {
    
    @State private var showConsentManagement = false
    
    var body: some View {
        VStack {
            Text("Hello, world!")
        }
        .padding()
        .usercentrics(isPresented: $showConsentManagement)
    }
}

#Preview {
    ContentView()
}

import SwiftUI

struct OnIsPresentedViewModifier: ViewModifier {
    
    fileprivate let isPresented: (Bool) -> Void
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var appeared = false
    
    func body(content: Content) -> some View {
        content
            .onUIKitAppear {
                appeared = true
                isPresented(true)
            }
            .onUIKitDisappear {
                appeared = false
                isPresented(false)
            }
            .onChange(of: scenePhase) { phase in
                guard appeared else { return }
                switch phase {
                case .active:
                    isPresented(true)
                case .inactive:
                    isPresented(false)
                default: break
                }
            }
    }
}

public extension View {
    /// Sends a `Bool` value every time this view is appearing/disappearing on the screen (through navigation or through app resume/backgrounding).
    /// Corresponds to the Tracking logic for PageView Events.
    func onIsPresented(onChange: @escaping (Bool) -> Void) -> some View {
        self.modifier(OnIsPresentedViewModifier(isPresented: onChange))
    }
}


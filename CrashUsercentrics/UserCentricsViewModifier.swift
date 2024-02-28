import SwiftUI
import Usercentrics
import UsercentricsUI

extension View {
    @MainActor
    public func usercentrics(isPresented: Binding<Bool>) -> some View {
        modifier(UsercentricsViewModifier(isPresented: isPresented))
    }
}

@MainActor
struct UsercentricsViewModifier: ViewModifier {
    @State var task: Task<Void, Never>?
    @Binding var isShowingBanner: Bool
    
    init(isPresented: Binding<Bool>) {
        _isShowingBanner = isPresented
    }
    
    func body(content: Content) -> some View {
        content
            .onIsPresented { isPresented in
                if isPresented {
                    checkUsercentricsStatus()
                } else {
                    task?.cancel()
                    task = nil
                }
            }
    }
    
    private func checkUsercentricsStatus() {
        guard task == nil else { return }
        task = Task {
            guard let status = try? await status() else { return }
            if status.shouldCollectConsent {
                showConsentView()
            }
        }
    }
    
    public func status() async throws -> UsercentricsReadyStatus {
        try await withCheckedThrowingContinuation { continuation in
            UsercentricsCore.isReady { status in
                // we apply user consent for app services here (e.g. disbling of TrackingServices)
                // ommited code in this demo project
                continuation.resume(returning: status)
            } onFailure: { error in
                continuation.resume(throwing: error)
            }
        }
    }
    
    private func showConsentView(layout: UsercentricsLayout = .sheet) {
        guard !isShowingBanner,
              let topMostViewController = UIApplication.shared.topMostViewController else { return }
        
        // avoid "Attempt to present <UsercentricsUI.BottomSheetContainerViewController: ...> on <UINavigationController: ..> (from <UINavigationController: ..>) whose view is not in the window hierarchy."
        // do not show banner if another sheet is already presented, we will check
        // shouldCollectConsent again with next scene phase change to foreground
        if !topMostViewController.isBeingPresented {
            let banner = UsercentricsBanner()
            banner.showFirstLayer(hostView: topMostViewController) { response in
                // we apply user consent for app services here (e.g. disbling of TrackingServices)
                // ommited code in this demo project
                isShowingBanner = false
            }
            isShowingBanner = true
        }
    }
    
    
}

import SwiftUI

private struct UIKitLifecycle: UIViewControllerRepresentable {
    let onAppear: (() -> Void)?
    let onDisappear: (() -> Void)?
    
    func makeUIViewController(context: Context) -> UIKitLifecycleViewController {
        let viewController = UIKitLifecycleViewController()
        viewController.coordinator = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ controller: UIKitLifecycleViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onAppear: onAppear, onDisappear: onDisappear)
    }
    
    class Coordinator {
        var onAppear: (() -> Void)?
        var onDisappear: (() -> Void)?
        
        init(onAppear: (() -> Void)? = nil, onDisappear: (() -> Void)? = nil) {
            self.onAppear = onAppear
            self.onDisappear = onDisappear
        }
    }
}

private class UIKitLifecycleViewController: UIViewController {
    weak var coordinator: UIKitLifecycle.Coordinator?
    
    override func viewDidLoad() {
        view.addSubview(UILabel())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        coordinator?.onAppear?()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        coordinator?.onDisappear?()
    }
}

public extension View {
    func onUIKitAppear(_ perform: @escaping () -> Void) -> some View {
        background(UIKitLifecycle(onAppear: perform, onDisappear: nil))
    }
    
    func onUIKitDisappear(_ perform: @escaping () -> Void) -> some View {
        background(UIKitLifecycle(onAppear: nil, onDisappear: perform))
    }
    
    func updateUIKitIsViewVisible(_ isViewVisible: Binding<Bool>) -> some View {
        background(UIKitLifecycle(
            onAppear: { isViewVisible.wrappedValue = true },
            onDisappear: { isViewVisible.wrappedValue = false }
        ))
    }
}

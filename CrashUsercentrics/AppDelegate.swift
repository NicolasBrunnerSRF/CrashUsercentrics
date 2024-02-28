import UIKit
import Usercentrics

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let options = UsercentricsOptions()
        options.ruleSetId = "xxx"   // TODO: Set your Usercentrics project id
        UsercentricsCore.configure(options: options)
        
        return true
    }
}

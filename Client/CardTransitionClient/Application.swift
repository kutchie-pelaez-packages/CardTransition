import UIKit

final class Application: UIApplication, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let window = UIWindow()
        let rootViewController = PresentingViewController()

        window.rootViewController = rootViewController
        window.makeKeyAndVisible()

        self.window = window

        return true
    }
}

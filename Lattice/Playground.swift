import UIKit

protocol Router: Routable { // potentially infinite (appendable) set of routables
    static func create(routable: Routable) -> Self
}
extension Router {
    
    private static func buildViewController(from renderable: Renderable) -> UIViewController {
        switch renderable {
        case let vc as UIViewController:
            return vc
        case let view as UIView:
            let vc = UIViewController()
            vc.view.addSubview(view)
            return vc
        case let layer as CALayer:
            let view = UIView()
            view.layer.addSublayer(layer)
            let vc = UIViewController()
            vc.view.addSubview(view)
            return vc
        default:
            assertionFailure(); return UIViewController()
        }
    }
}

extension UINavigationController: Router {
    var display: Renderable {
        return view
    }
    
    static func create(routable: Routable) -> Self {
        let renderable = routable.display
        
        let viewController = UINavigationController.buildViewController(from: renderable)
        return self.init(rootViewController: viewController)
    }
}
extension UIWindow: Router {
    var display: Renderable {
        return self
    }
    
    static func create(routable: Routable) -> Self {
        let renderable = routable.display
        let viewController = UIWindow.buildViewController(from: renderable)
        let navController = UINavigationController(rootViewController: viewController)
        let window = self.init(frame: UIScreen.mainScreen().bounds)
        window.rootViewController = navController
        return window
    }
}

protocol Renderable {}
extension UIViewController: Renderable {}
extension UIView: Renderable {}

protocol Routable {
    var display: Renderable { get }
}

protocol Unit: Routable {}

protocol Container: Routable {} // discrete set of routables
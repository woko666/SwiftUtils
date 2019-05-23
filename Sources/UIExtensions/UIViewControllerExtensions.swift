import Foundation
import UIKit

// MARK: Dialogs
extension UIViewController {
    
    public func showOkDialog(title:String, message:String, ok:String, handler:((UIAlertAction)->Void)? = nil) {
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: ok, style: .default, handler: handler))
        self.present(alert, animated: true)
    }
    
}

// MARK: Embed container view to view
extension UIViewController {
    
    public func embedContainerView(_ controller: UIViewController, containerView: UIView) {
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        
        controller.didMove(toParent: self)
    }
}

// MARK: Backgroundable
extension UIViewController {
    
    open func initBackgroundable() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationBecameActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationBecameInactive), name: UIApplication.willResignActiveNotification, object: nil) // selector "methodname:" also possible?
        applicationBecameActive(notification:NSNotification(name: UIApplication.didBecomeActiveNotification,object:nil))
    }
    
    @objc open func applicationBecameActive(notification: NSNotification) {
        
    }
    
    @objc open func applicationBecameInactive(notification: NSNotification) {
        
    }
}

import Foundation
import UIKit

public extension UIImageView {
    public var setColor:UIColor {
        set {
            let origImage = self.image
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            self.image = tintedImage
            tintColor = newValue
        }
        get {
            return tintColor
        }
    }
}

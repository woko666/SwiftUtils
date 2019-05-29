import Foundation
import UIKit

public extension UIButton {
    var setColor:UIColor {
        set {
            let origImage = self.image(for: .normal)
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            setImage(tintedImage, for: .normal)
            tintColor = newValue
        }
        get {
            return tintColor
        }
    }
}

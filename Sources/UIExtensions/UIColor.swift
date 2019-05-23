import Foundation
import UIKit

extension UIColor {
    public convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask: UInt32 = 0x000000FF
        let r = UInt32(color >> 16) & mask
        let g = UInt32(color >> 8) & mask
        let b = UInt32(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    public var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb: UInt32 = (UInt32)(r * 255) << 16 | (UInt32)(g * 255) << 8 | (UInt32)(b * 255) << 0
        
        return String(format: "%06x", rgb)
    }
}

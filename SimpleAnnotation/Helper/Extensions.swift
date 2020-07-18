//
//  Extensions.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 6/29/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

// MARK: -

extension UIColor {
    
    // Color from hex
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex: Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    // Custom colors
    struct Design {
        static let background = UIColor(netHex: 0xF4F4F4)
        static let navigationBar = UIColor(netHex: 0x303030)
    }
    
    struct Colors {
        static let red = UIColor.systemRed
        static let orange = UIColor.systemOrange
        static let yellow = UIColor.systemYellow
        static let green = UIColor.systemGreen
        static let teal = UIColor.systemTeal
        static let blue = UIColor.systemBlue
        static let purple = UIColor.systemPurple
    }
    
}

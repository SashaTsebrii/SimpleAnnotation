//
//  ColorButton.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 9/4/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class ColorButton: UIButton {

    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderColor = UIColor.gray.cgColor
                layer.borderWidth = 4
            } else {
                layer.borderColor = UIColor.clear.cgColor
                layer.borderWidth = 0
            }
        }
    }

}

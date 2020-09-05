//
//  OpacityButton.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 9/5/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class OpacityButton: UIButton {

    override var isSelected: Bool {
        didSet {
            layer.cornerRadius = 4
            if isSelected {
                backgroundColor = .darkGray
            } else {
                backgroundColor = .clear
            }
        }
    }

}

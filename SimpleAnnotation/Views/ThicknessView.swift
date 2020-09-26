//
//  ThicknessView.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 9/25/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class ThicknessView: UIView {

    var value: CGFloat {
        didSet {
            valueView.frame.size.width = value
            valueView.frame.size.height = value
            valueView.layer.cornerRadius = value / 2
        }
    }
    
    fileprivate lazy var valueView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()
    
    init(value: CGFloat, frame: CGRect) {
        
        self.value = value
        
        super.init(frame: frame)
        
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(valueView)
        valueView.center = center
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

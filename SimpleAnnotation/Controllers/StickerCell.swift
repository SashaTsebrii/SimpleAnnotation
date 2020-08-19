//
//  StickerCell.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 8/19/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class StickerCell: UICollectionViewCell {
    
    // MARK: Variables
    
    static let identifier = "StickerCell"
    
    var sticker: UIImage? {
        didSet {
            stickerImageView.image = sticker
        }
    }
    
    // MARK: Properties
    
    let stickerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(stickerImageView)
        NSLayoutConstraint.activate([
            stickerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stickerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stickerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stickerImageView.bottomAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

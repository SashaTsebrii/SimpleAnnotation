//
//  NoteImageView.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 9/21/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

protocol NoteImageViewDelegate {
    func noteTapped(none: Note)
}

class NoteImageView: EditableImageView {
    
    var delegate: NoteImageViewDelegate?
    var note: Note
    
    init(withNote note: Note, frame: CGRect) {
        self.note = note
        
        super.init(frame: frame)
        
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(handleTapGesture(_:)))
        addGestureRecognizer(tapGesture)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        print("👋 TAP GESTURE IN NOTE IMAGE VIEW")

//        let enterTextController = EnterTextController()
//        enterTextController.delegate = self
//        navigationController?.pushViewController(enterTextController, animated: true)

    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        print("👋 PAN GESTURE IN NOTE IMAGE VIEW")
        
        let translation = gesture.translation(in: superview)
        
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.center = CGPoint(x: gestureView.center.x + translation.x, y: gestureView.center.y + translation.y)
        gesture.setTranslation(.zero, in: superview)
        
    }
    
}

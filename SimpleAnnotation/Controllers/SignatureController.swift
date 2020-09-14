//
//  SignatureController.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 8/19/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

protocol SignatureControllerDelegate {
    func signatureParameter(signatureImage: UIImage?)
    func cancel()
}

class SignatureController: UIViewController {
    
    // MARK: Variables
    
    var delegate: SignatureControllerDelegate?
        
    var fullView: CGFloat {
        let navigationBarHeight = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        return UIScreen.main.bounds.height - (signatureImageView.frame.maxY + navigationBarHeight)
    }
    
    var partialView: CGFloat {
        let navigationBarHeight = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        return UIScreen.main.bounds.height - (signatureImageView.frame.maxY + navigationBarHeight)
    }
    
    // MARK: Properties
    
    let signatureImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let signatureView: SignatureView = {
        let signatureView = SignatureView(frame: .zero)
        signatureView.backgroundColor = .white
        signatureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        signatureView.isUserInteractionEnabled = true
        signatureView.translatesAutoresizingMaskIntoConstraints = false
        signatureView.isHidden = true
        return signatureView
    }()
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        // holdView
        let holdView = UIView(frame: .zero)
        holdView.layer.cornerRadius = 2
        holdView.layer.masksToBounds = true
        holdView.backgroundColor = .lightGray
        holdView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(holdView)
        NSLayoutConstraint.activate([
            holdView.widthAnchor.constraint(equalToConstant: 64),
            holdView.heightAnchor.constraint(equalToConstant: 4),
            holdView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            holdView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8)
        ])
        
        // titleLabel
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = "Signature"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: holdView.bottomAnchor, constant: 16)
        ])
        
        // imageView
        view.addSubview(signatureImageView)
        NSLayoutConstraint.activate([
            signatureImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            signatureImageView.heightAnchor.constraint(equalTo: signatureImageView.widthAnchor),
            signatureImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signatureImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32)
        ])
        
        // createButton
        let createButton = UIButton(frame: .zero)
        createButton.setTitle("CREATE", for: .normal)
        createButton.setTitleColor(.black, for: .normal)
        createButton.addTarget(self, action: #selector(createButtonTapped(_:)), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(createButton)
        NSLayoutConstraint.activate([
            createButton.heightAnchor.constraint(equalToConstant: 44),
            createButton.bottomAnchor.constraint(equalTo: signatureImageView.bottomAnchor),
            createButton.leadingAnchor.constraint(equalTo: signatureImageView.leadingAnchor)
        ])
        
        // useButton
        let useButton = UIButton(frame: .zero)
        useButton.setTitle("USE", for: .normal)
        useButton.setTitleColor(.black, for: .normal)
        useButton.addTarget(self, action: #selector(useButtonTapped(_:)), for: .touchUpInside)
        useButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(useButton)
        NSLayoutConstraint.activate([
            useButton.heightAnchor.constraint(equalToConstant: 44),
            useButton.bottomAnchor.constraint(equalTo: signatureImageView.bottomAnchor),
            useButton.centerXAnchor.constraint(equalTo: signatureImageView.centerXAnchor)
        ])
        
        // cancelButton
        let cancelButton = UIButton(frame: .zero)
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.bottomAnchor.constraint(equalTo: signatureImageView.bottomAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: signatureImageView.trailingAnchor)
        ])
                
        // signatureView
        view.addSubview(signatureView)
        NSLayoutConstraint.activate([
            signatureView.widthAnchor.constraint(equalTo: view.widthAnchor),
            signatureView.heightAnchor.constraint(equalTo: signatureImageView.widthAnchor),
            signatureView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signatureView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32)
        ])
        
        // closeButto
        let closeButton = UIButton(frame: .zero)
        closeButton.setTitle("CLOSE", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        signatureView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.bottomAnchor.constraint(equalTo: signatureView.bottomAnchor),
            closeButton.leadingAnchor.constraint(equalTo: signatureView.leadingAnchor)
        ])
        
        // doneButton
        let doneButton = UIButton(frame: .zero)
        doneButton.setTitle("DONE", for: .normal)
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        signatureView.addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.heightAnchor.constraint(equalToConstant: 44),
            doneButton.bottomAnchor.constraint(equalTo: signatureView.bottomAnchor),
            doneButton.trailingAnchor.constraint(equalTo: signatureView.trailingAnchor)
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        prepareBackgroundView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Gestures
    
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        let velocity = sender.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            sender.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if sender.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
            }, completion: nil)
        }
    }
    
    @objc fileprivate func createButtonTapped(_ sender: UIButton) {
        print("👆 CREATE BUTTON")
        
        if signatureImageView.image != nil {
            signatureImageView.image = nil
        }
        
        signatureView.isHidden = false
        
    }
    
    @objc fileprivate func useButtonTapped(_ sender: UIButton) {
        print("👆 USE BUTTON")
        
        if signatureImageView.image != nil {
            delegate?.signatureParameter(signatureImage: signatureImageView.image)
        }
        
    }
    
    @objc fileprivate func cancelButtonTapped(_ sender: UIButton) {
        print("👆 CANCEL BUTTON")
        
        delegate?.cancel()
        
    }
    
    @objc fileprivate func closeButtonTapped(_ sender: UIButton) {
        print("👆 CLOSE BUTTON")
        
        signatureView.resetDrawing()
        signatureView.isHidden = true
        
    }
    
    @objc fileprivate func doneButtonTapped(_ sender: UIButton) {
        print("👆 DONE BUTTON")
        
        signatureImageView.image = signatureView.exportDrawing()
        signatureView.isHidden = true
        
    }
    
    // MARK: Helper
    
    func prepareBackgroundView() {
        
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        
        view.insertSubview(bluredView, at: 0)
        
    }
    
}

extension SignatureController: UIGestureRecognizerDelegate {
    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

        if let touchedView = touch.view, touchedView.isKind(of: UISlider.self) {
            return false
        }

        return true
    }
    
}

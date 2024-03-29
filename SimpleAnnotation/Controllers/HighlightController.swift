//
//  HighlightController.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 8/13/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

protocol HighlightControllerDelegate {
    func highlightParameter(color: UIColor, opacity: CGFloat)
    func cancelHighlight()
}

class HighlightController: UIViewController {
    
    // MARK: Variables
    
    var delegate: HighlightControllerDelegate?
    
    var color: UIColor = .yellow {
        didSet {
            delegate?.highlightParameter(color: color, opacity: opacity)
        }
    }
    
    var opacity: CGFloat = 0.6 {
        didSet {
            delegate?.highlightParameter(color: color, opacity: opacity)
        }
    }
    
    var fullView: CGFloat {
        let navigationBarHeight = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        return UIScreen.main.bounds.height - (opacitiesStack.frame.maxY + navigationBarHeight)
    }
    
    var partialView: CGFloat {
        let navigationBarHeight = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        return UIScreen.main.bounds.height - (colorsStack.frame.maxY + navigationBarHeight)
    }
    
    var colorButtons: [ColorButton] = []
    var opacityButtons: [OpacityButton] = []
    
    // MARK: Properties
    
    let colorsStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.spacing = 0
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let opacitiesStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.spacing = 0
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        titleLabel.text = "Highlight"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: holdView.bottomAnchor, constant: 16)
        ])
        
        // closeButton
        let closeButton = UIButton(frame: .zero)
        closeButton.setTitle("Close", for: .normal)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        // colorLabel
        let colorLabel = UILabel(frame: .zero)
        colorLabel.text = "COLOR"
        colorLabel.textColor = .gray
        colorLabel.font = UIFont.systemFont(ofSize: 14)
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(colorLabel)
        NSLayoutConstraint.activate([
            colorLabel.heightAnchor.constraint(equalToConstant: 16),
            colorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            colorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        // colorsStack
        let colors = [UIColor.Colors.red, UIColor.Colors.orange, UIColor.Colors.yellow, UIColor.Colors.green, UIColor.Colors.teal, UIColor.Colors.blue, UIColor.Colors.purple]
        
        for index in 0...(colors.count - 1) {
            
            let colorButton = ColorButton(frame: .zero)
            colorButton.layer.cornerRadius = 16
            colorButton.layer.masksToBounds = true
            colorButton.backgroundColor = colors[index]
            colorButton.addTarget(self, action: #selector(handleColorChange(_:)), for: .touchUpInside)
            colorButton.translatesAutoresizingMaskIntoConstraints = false
            
            if index == 0 {
                colorButton.isSelected = true
            } else {
                colorButton.isSelected = false
            }
            
            colorButtons.append(colorButton)
            colorsStack.addArrangedSubview(colorButton)
            
        }
        
        for button in colorsStack.arrangedSubviews {
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 32),
                button.heightAnchor.constraint(equalTo: button.widthAnchor)
            ])
        }
        
        view.addSubview(colorsStack)
        NSLayoutConstraint.activate([
            colorsStack.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 16),
            colorsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            colorsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        // opacityLabel
        let opacityLabel = UILabel(frame: .zero)
        opacityLabel.text = "OPACITY"
        opacityLabel.textColor = .gray
        opacityLabel.font = UIFont.systemFont(ofSize: 14)
        opacityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(opacityLabel)
        NSLayoutConstraint.activate([
            opacityLabel.heightAnchor.constraint(equalToConstant: 16),
            opacityLabel.topAnchor.constraint(equalTo: colorsStack.bottomAnchor, constant: 48),
            opacityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        // opacityStack
        let opacities: [CGFloat] = [30, 60, 90]
        
        for index in 0...(opacities.count - 1) {
            
            let opacityButton = OpacityButton(frame: .zero)
            opacityButton.setImage(UIImage(named: "circle"), for: .normal)
            opacityButton.tintColor = UIColor.yellow.withAlphaComponent(opacities[index] / 100)
            opacityButton.setTitle("\(opacities[index])%", for: .normal)
            opacityButton.titleLabel?.textColor = .white
            opacityButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            opacityButton.contentHorizontalAlignment = .left
            opacityButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            opacityButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
            
            opacityButton.addTarget(self, action: #selector(handleOpactityChange(_:)), for: .touchUpInside)
            opacityButton.translatesAutoresizingMaskIntoConstraints = false
            
            // FIXME: put title bellow and add image with needed color and opacity instat of background color
            
            if index == 0 {
                opacityButton.isSelected = true
            } else {
                opacityButton.isSelected = false
            }
            
            opacityButtons.append(opacityButton)
            opacitiesStack.addArrangedSubview(opacityButton)
            
        }
        
        view.addSubview(opacitiesStack)
        NSLayoutConstraint.activate([
            opacitiesStack.heightAnchor.constraint(equalToConstant: 44),
            opacitiesStack.topAnchor.constraint(equalTo: opacityLabel.bottomAnchor, constant: 16),
            opacitiesStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            opacitiesStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        prepareBackgroundView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    // MARK: Actions
    
    @objc fileprivate func handleColorChange(_ sender: UIButton) {
        
        if sender.isSelected == false {
            
            for button in colorButtons {
                button.isSelected = false
            }
            sender.isSelected = true
            
        }
        
        color = sender.backgroundColor ?? .black
        
    }
    
    @objc fileprivate func handleOpactityChange(_ sender: UIButton) {
        
        if sender.isSelected == false {
            
            for button in opacityButtons {
                button.isSelected = false
            }
            sender.isSelected = true
            
        }
        
        if let number = NumberFormatter().number(from: String(sender.titleLabel!.text!.dropLast())) {
            opacity = CGFloat(truncating: number) / 100
        }
        
    }
    
    @objc fileprivate func closeButtonTapped(_ sender: UIButton) {
        delegate?.cancelHighlight()
    }
    
    // MARK: Gestures
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
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
    
    func close() {
        
        UIView.animate(withDuration: 0.3, animations: {
            let frame = self.view.frame
            self.view.frame = CGRect(x: 0, y: self.partialView, width: frame.width, height: frame.height)
        })
        
    }
    
}

extension HighlightController: UIGestureRecognizerDelegate {
    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

        if let touchedView = touch.view, touchedView.isKind(of: UISlider.self) {
            return false
        }

        return true
    }
    
}

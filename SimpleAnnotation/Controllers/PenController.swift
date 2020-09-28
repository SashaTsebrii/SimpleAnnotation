//
//  PenController.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 6/29/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

protocol PenControllerDelegate {
    func penParameter(color: UIColor, thinkness: CGFloat)
    func cancelPen()
}

class PenController: UIViewController {
    
    // MARK: Variables
    
    var delegate: PenControllerDelegate?
    
    var color: UIColor = .black {
        didSet {
            delegate?.penParameter(color: color, thinkness: thikness)
        }
    }
    
    var thikness: CGFloat = 3.0 {
        didSet {
            delegate?.penParameter(color: color, thinkness: thikness)
        }
    }
    
    var fullView: CGFloat {
        let navigationBarHeight = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        return UIScreen.main.bounds.height - (thicknessSlider.frame.maxY + navigationBarHeight)
    }
    
    var partialView: CGFloat {
        let navigationBarHeight = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        return UIScreen.main.bounds.height - (colorsStack.frame.maxY + navigationBarHeight)
    }
    
    var colorButtons: [ColorButton] = []
    
    // MARK: Properties
    
    let colorsStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.spacing = 0
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let thicknessView: ThicknessView = {
        let view = ThicknessView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        return view
    }()
    
    let thicknessSizeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var thicknessSlider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.isContinuous = true
        slider.setValue(3, animated: false)
        slider.addTarget(self, action: #selector(handleSliderChange(_:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        thicknessView.value = 3
        thicknessSizeLabel.text = "3"
        
        return slider
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
        titleLabel.text = "Pen"
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
        let colors = [UIColor.black, UIColor.white, UIColor.Colors.red, UIColor.Colors.orange, UIColor.Colors.yellow, UIColor.Colors.green, UIColor.Colors.teal, UIColor.Colors.blue, UIColor.Colors.purple]
        
        for index in 0...(colors.count - 1) {
            
            let colorButton = ColorButton(frame: .zero)
            colorButton.layer.cornerRadius = 16
            colorButton.layer.masksToBounds = true
            colorButton.backgroundColor = colors[index]
            colorButton.addTarget(self, action: #selector(handleColorChange(_:)), for: .touchUpInside)
            colorButton.translatesAutoresizingMaskIntoConstraints = false
            
            // FIXME: Save previous parameter to user defaults and load it if it was saved at it session
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
        
        // thicknessLabel
        let thicknessLabel = UILabel(frame: .zero)
        thicknessLabel.text = "THICKNESS"
        thicknessLabel.textColor = .gray
        thicknessLabel.font = UIFont.systemFont(ofSize: 14)
        thicknessLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(thicknessLabel)
        NSLayoutConstraint.activate([
            thicknessLabel.heightAnchor.constraint(equalToConstant: 16),
            thicknessLabel.topAnchor.constraint(equalTo: colorsStack.bottomAnchor, constant: 32),
            thicknessLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        // thicknessSlider
        view.addSubview(thicknessView)
        view.addSubview(thicknessSizeLabel)
        view.addSubview(thicknessSlider)
        NSLayoutConstraint.activate([
            thicknessView.widthAnchor.constraint(equalToConstant: 32),
            thicknessView.heightAnchor.constraint(equalTo: thicknessView.widthAnchor),
            
            thicknessSizeLabel.widthAnchor.constraint(equalToConstant: 32),
            thicknessSizeLabel.heightAnchor.constraint(equalTo: thicknessSizeLabel.widthAnchor),
            
            thicknessSlider.topAnchor.constraint(equalTo: thicknessLabel.bottomAnchor, constant: 32),
            
            thicknessView.centerYAnchor.constraint(equalTo: thicknessSlider.centerYAnchor),
            thicknessView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            thicknessSizeLabel.centerYAnchor.constraint(equalTo: thicknessSlider.centerYAnchor),
            thicknessSizeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            thicknessSlider.leadingAnchor.constraint(equalTo: thicknessView.trailingAnchor, constant: 16),
            thicknessSlider.trailingAnchor.constraint(equalTo: thicknessSizeLabel.leadingAnchor, constant: -16)
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
    
    @objc func handleSliderChange(_ sender: UISlider) {
        
        let roundValue = roundf(sender.value);
        
        print(sender.value)
        print(Int(roundValue))
        
        thicknessSizeLabel.text = String(Int(roundValue))
        thikness = CGFloat(roundValue)
        
        thicknessView.value = CGFloat(roundValue)
        thicknessView.frame.size.width = CGFloat(roundValue)
        
    }
    
    @objc fileprivate func closeButtonTapped(_ sender: UIButton) {
        delegate?.cancelPen()
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
    
}

extension PenController: UIGestureRecognizerDelegate {
    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

        if let touchedView = touch.view, touchedView.isKind(of: UISlider.self) {
            return false
        }

        return true
    }
    
}

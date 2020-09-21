//
//  EnterTextController.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 9/19/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

protocol EnterTextControllerDelegate {
    func enteredText(text: String)
}

class EnterTextController: UIViewController {
    
    // MARK: Variables
    
    var delegate: EnterTextControllerDelegate?
    var text: String? {
        didSet {
            if let text = text {
                textView.text = text
            }
        }
    }
    
    // MARK: Properties
    
    let textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.textAlignment = .center
        textView.contentMode = .center
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        // Set title
        title = "Text"
        
        // Set background color
        view.backgroundColor = UIColor.Design.background
        
        // cancelButton
        navigationItem.hidesBackButton = true
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBarButtonTapped(_:)))
        navigationItem.leftBarButtonItem = cancelBarButton
        
        // doneBarButton
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = doneBarButton
        
        // textView
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
        
    }
    
    // MARK: Actions
    
    @objc fileprivate func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc fileprivate func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        
        if let text = textView.text {
            if text.count > 0 {
                delegate?.enteredText(text: text)
                navigationController?.popViewController(animated: true)
            } else {
                let alert = UIAlertController(title: "The note is empty", message: "Enter text to create or save a note", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

                self.present(alert, animated: true)
            }
        }
        
    }
    
}

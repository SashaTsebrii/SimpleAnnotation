//
//  AnnotationController.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 6/29/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit
import PDFKit
import CoreData

class AnnotationController: UIViewController {
    
    // MARK: Variables
    
    var document: Document?
    
    var penController: PenController?
    var markerController: MarkerController?
    var highlightController: HighlightController?
    
    var textController: TextController?
    var shapesController: ShapesController?
    var noteController: NoteController?
    var stickersController: StickersController?
    var signatureController: SignatureController?
    
    // MARK: Prpperties
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.text = "SimpleAnnotation"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.text = "Annotation"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    fileprivate let toolbarScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    fileprivate let toolbarContentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var previewScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    fileprivate let pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.backgroundColor = .clear
        pdfView.autoScales = true
        pdfView.displayDirection = .vertical
        pdfView.isUserInteractionEnabled = false
        pdfView.displayMode = .singlePage
        pdfView.pageShadowsEnabled = false
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        return pdfView
    }()
    
    fileprivate let clearButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "clear"), for: .normal)
        button.addTarget(self, action: #selector(clearButtonTapped(_:)), for: .touchUpInside)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let undoButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "undo"), for: .normal)
        button.addTarget(self, action: #selector(undoButtonTapped(_:)), for: .touchUpInside)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let canvasView: CanvasView = {
        let view = CanvasView(frame: .zero)
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let annotationView: AnnotationView = {
        let view = AnnotationView(frame: .zero)
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        // Set title
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        titleStack.axis = .vertical
        navigationItem.titleView = titleStack
        
        // Set background color
        view.backgroundColor = UIColor.Design.background
        
        // Create save bar button item
        let saveButton = UIButton(frame: .zero)
        saveButton.tintColor = .black
        saveButton.setImage(UIImage(named: "save"), for: .normal)
        saveButton.addTarget(self, action: #selector(saveBarButtonTapped(_:)), for: .touchUpInside)
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = saveBarButton
        
        // clearButton
        view.addSubview(clearButton)
        NSLayoutConstraint.activate([
            clearButton.widthAnchor.constraint(equalToConstant: 44),
            clearButton.heightAnchor.constraint(equalTo: clearButton.widthAnchor),
            clearButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            clearButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        
        // undoButton
        view.addSubview(undoButton)
        NSLayoutConstraint.activate([
            undoButton.widthAnchor.constraint(equalToConstant: 44),
            undoButton.heightAnchor.constraint(equalTo: undoButton.widthAnchor),
            undoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            undoButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        // scrollView
        view.addSubview(toolbarScrollView)
        NSLayoutConstraint.activate([
            toolbarScrollView.heightAnchor.constraint(equalToConstant: 44),
            toolbarScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toolbarScrollView.leadingAnchor.constraint(equalTo: clearButton.trailingAnchor, constant: 1),
            toolbarScrollView.trailingAnchor.constraint(equalTo: undoButton.leadingAnchor, constant: -1)
        ])
        
        // Content view
        toolbarScrollView.addSubview(toolbarContentView)
        NSLayoutConstraint.activate([
            toolbarContentView.widthAnchor.constraint(equalToConstant: (44 * 8) + (4 * 8)),
            toolbarContentView.centerYAnchor.constraint(equalTo: toolbarScrollView.centerYAnchor),
            toolbarContentView.topAnchor.constraint(equalTo: toolbarScrollView.topAnchor),
            toolbarContentView.bottomAnchor.constraint(equalTo: toolbarScrollView.bottomAnchor),
            toolbarContentView.leadingAnchor.constraint(equalTo: toolbarScrollView.leadingAnchor),
            toolbarContentView.trailingAnchor.constraint(equalTo: toolbarScrollView.trailingAnchor)
        ])
        
        // penButton
        let penButton = UIButton(frame: .zero)
        penButton.setImage(UIImage(named: "pen"), for: .normal)
        penButton.addTarget(self, action: #selector(penButtonTapped(_:)), for: .touchUpInside)
        penButton.translatesAutoresizingMaskIntoConstraints = false
        
        toolbarContentView.addSubview(penButton)
        NSLayoutConstraint.activate([
            penButton.widthAnchor.constraint(equalToConstant: 44),
            penButton.heightAnchor.constraint(equalTo: penButton.widthAnchor),
            penButton.leadingAnchor.constraint(equalTo: toolbarContentView.leadingAnchor, constant: 4),
            penButton.centerYAnchor.constraint(equalTo: toolbarContentView.centerYAnchor)
        ])
        
        // markerButton
        let markerButton = UIButton(frame: .zero)
        markerButton.setImage(UIImage(named: "marker"), for: .normal)
        markerButton.addTarget(self, action: #selector(markerButtonTapped(_:)), for: .touchUpInside)
        markerButton.translatesAutoresizingMaskIntoConstraints = false
        
        toolbarContentView.addSubview(markerButton)
        NSLayoutConstraint.activate([
            markerButton.widthAnchor.constraint(equalToConstant: 44),
            markerButton.heightAnchor.constraint(equalTo: markerButton.widthAnchor),
            markerButton.leadingAnchor.constraint(equalTo: penButton.trailingAnchor, constant: 4),
            markerButton.centerYAnchor.constraint(equalTo: toolbarContentView.centerYAnchor)
        ])
        
        // highlightButton
        let highlightButton = UIButton(frame: .zero)
        highlightButton.setImage(UIImage(named: "highlight"), for: .normal)
        highlightButton.addTarget(self, action: #selector(highlightButtonTapped(_:)), for: .touchUpInside)
        highlightButton.translatesAutoresizingMaskIntoConstraints = false
        
        toolbarContentView.addSubview(highlightButton)
        NSLayoutConstraint.activate([
            highlightButton.widthAnchor.constraint(equalToConstant: 44),
            highlightButton.heightAnchor.constraint(equalTo: highlightButton.widthAnchor),
            highlightButton.leadingAnchor.constraint(equalTo: markerButton.trailingAnchor, constant: 4),
            highlightButton.centerYAnchor.constraint(equalTo: toolbarContentView.centerYAnchor)
        ])
        
        // textButton
        let textButton = UIButton(frame: .zero)
        textButton.setImage(UIImage(named: "text"), for: .normal)
        textButton.addTarget(self, action: #selector(textButtonTapped(_:)), for: .touchUpInside)
        textButton.translatesAutoresizingMaskIntoConstraints = false
        
        toolbarContentView.addSubview(textButton)
        NSLayoutConstraint.activate([
            textButton.widthAnchor.constraint(equalToConstant: 44),
            textButton.heightAnchor.constraint(equalTo: textButton.widthAnchor),
            textButton.leadingAnchor.constraint(equalTo: highlightButton.trailingAnchor, constant: 4),
            textButton.centerYAnchor.constraint(equalTo: toolbarContentView.centerYAnchor)
        ])
        
        // shapesButton
        let shapesButton = UIButton(frame: .zero)
        shapesButton.setImage(UIImage(named: "shapes"), for: .normal)
        shapesButton.addTarget(self, action: #selector(shapesButtonTapped(_:)), for: .touchUpInside)
        shapesButton.translatesAutoresizingMaskIntoConstraints = false
        
        toolbarContentView.addSubview(shapesButton)
        NSLayoutConstraint.activate([
            shapesButton.widthAnchor.constraint(equalToConstant: 44),
            shapesButton.heightAnchor.constraint(equalTo: shapesButton.widthAnchor),
            shapesButton.leadingAnchor.constraint(equalTo: textButton.trailingAnchor, constant: 4),
            shapesButton.centerYAnchor.constraint(equalTo: toolbarContentView.centerYAnchor)
        ])
        
        // noteButton
        let noteButton = UIButton(frame: .zero)
        noteButton.setImage(UIImage(named: "note"), for: .normal)
        noteButton.addTarget(self, action: #selector(noteButtonTapped(_:)), for: .touchUpInside)
        noteButton.translatesAutoresizingMaskIntoConstraints = false
        
        toolbarContentView.addSubview(noteButton)
        NSLayoutConstraint.activate([
            noteButton.widthAnchor.constraint(equalToConstant: 44),
            noteButton.heightAnchor.constraint(equalTo: noteButton.widthAnchor),
            noteButton.leadingAnchor.constraint(equalTo: shapesButton.trailingAnchor, constant: 4),
            noteButton.centerYAnchor.constraint(equalTo: toolbarContentView.centerYAnchor)
        ])
        
        // stickersButton
        let stickersButton = UIButton(frame: .zero)
        stickersButton.setImage(UIImage(named: "stickers"), for: .normal)
        stickersButton.addTarget(self, action: #selector(stickersButtonTapped(_:)), for: .touchUpInside)
        stickersButton.translatesAutoresizingMaskIntoConstraints = false
        
        toolbarContentView.addSubview(stickersButton)
        NSLayoutConstraint.activate([
            stickersButton.widthAnchor.constraint(equalToConstant: 44),
            stickersButton.heightAnchor.constraint(equalTo: stickersButton.widthAnchor),
            stickersButton.leadingAnchor.constraint(equalTo: noteButton.trailingAnchor, constant: 4),
            stickersButton.centerYAnchor.constraint(equalTo: toolbarContentView.centerYAnchor)
        ])
        
        // signatureButton
        let signatureButton = UIButton(frame: .zero)
        signatureButton.setImage(UIImage(named: "signature"), for: .normal)
        signatureButton.addTarget(self, action: #selector(signatureButtonTapped(_:)), for: .touchUpInside)
        signatureButton.translatesAutoresizingMaskIntoConstraints = false
        
        toolbarContentView.addSubview(signatureButton)
        NSLayoutConstraint.activate([
            signatureButton.widthAnchor.constraint(equalToConstant: 44),
            signatureButton.heightAnchor.constraint(equalTo: signatureButton.widthAnchor),
            signatureButton.leadingAnchor.constraint(equalTo: stickersButton.trailingAnchor, constant: 4),
            signatureButton.centerYAnchor.constraint(equalTo: toolbarContentView.centerYAnchor)
        ])
        
        // previewScrollView
        view.addSubview(previewScrollView)
        NSLayoutConstraint.activate([
            previewScrollView.topAnchor.constraint(equalTo: toolbarScrollView.bottomAnchor),
            previewScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            previewScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            previewScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        previewScrollView.addSubview(pdfView)
        NSLayoutConstraint.activate([
            pdfView.centerXAnchor.constraint(equalTo: previewScrollView.centerXAnchor),
            pdfView.centerYAnchor.constraint(equalTo: previewScrollView.centerYAnchor),
            pdfView.topAnchor.constraint(equalTo: previewScrollView.topAnchor),
            pdfView.leadingAnchor.constraint(equalTo: previewScrollView.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: previewScrollView.trailingAnchor),
            pdfView.bottomAnchor.constraint(equalTo: previewScrollView.bottomAnchor)
        ])
        
        previewScrollView.addSubview(canvasView)
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: pdfView.topAnchor),
            canvasView.leadingAnchor.constraint(equalTo: pdfView.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: pdfView.trailingAnchor),
            canvasView.bottomAnchor.constraint(equalTo: pdfView.bottomAnchor)
        ])
        
        previewScrollView.addSubview(annotationView)
        NSLayoutConstraint.activate([
            annotationView.topAnchor.constraint(equalTo: pdfView.topAnchor),
            annotationView.leadingAnchor.constraint(equalTo: pdfView.leadingAnchor),
            annotationView.trailingAnchor.constraint(equalTo: pdfView.trailingAnchor),
            annotationView.bottomAnchor.constraint(equalTo: pdfView.bottomAnchor)
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPdfDocument()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: Actions
    
    @objc fileprivate func saveBarButtonTapped(_ sender: UIButton) {
        
        if let document = document {
            if let createDateString = document.createDateString, let editDateString = document.editDateString, let idString = document.idString {
                
                if createDateString == editDateString {
                    // First time edit, save to new derictory
                    
                    if let pdfDocument = pdfView.document {
                        
                        // Today date
                        let today = Date()
                        
                        // Create date string
                        let editDateFormatter = DateFormatter()
                        editDateFormatter.dateFormat = "MMM d, yyyy HH:mm"
                        let editDateString = editDateFormatter.string(from: today)
                        
                        // Get the data of PDF document
                        let data = pdfDocument.dataRepresentation()
                        
                        // Get directory
                        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let documentURL = documentDirectory.appendingPathComponent(idString + "edited")
                        print(documentURL)
                        let urlString = documentURL.path
                        print(urlString)
                        
                        // Save document to directory
                        do {
                            try data?.write(to: documentURL)
                        } catch (let error) {
                            print("Error save data to URL: \(error.localizedDescription)")
                        }
                        
                        // Get reference to AppDelegatesrefer
                        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                        
                        // Create a context
                        let managedContext = appDelegate.persistentContainer.viewContext
                        
                        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: Constants.kDocument.entityName)
                        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: Constants.kDocument.createDateString, ascending: false)]
                        fetchRequest.predicate = NSPredicate(format: "\(Constants.kDocument.idString) = %@", idString)
                        
                        do {
                            let documents = try managedContext.fetch(fetchRequest)
                            
                            let objectUpdate = documents.first! as! Document
                            objectUpdate.setValue(editDateString, forKey: Constants.kDocument.editDateString)
                            do {
                                try managedContext.save()
                            } catch {
                                print(error)
                            }
                        } catch {
                            print(error)
                        }
                        
                    }
                    
                } else {
                    // Not first time edit, resave file to previous derictory
                    
                    if let pdfDocument = pdfView.document {
                        
                        // Today date
                        let today = Date()
                        
                        // Create date string
                        let editDateFormatter = DateFormatter()
                        editDateFormatter.dateFormat = "MMM d, yyyy HH:mm"
                        let editDateString = editDateFormatter.string(from: today)
                        
                        // Get the data of PDF document
                        let data = pdfDocument.dataRepresentation()
                        
                        // Get directory
                        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let documentURL = documentDirectory.appendingPathComponent(idString+"edited")
                        print(documentURL)
                        let urlString = documentURL.path
                        print(urlString)
                        
                        // Save document to directory
                        do {
                            try data?.write(to: documentURL)
                        } catch (let error) {
                            print("Error save data to URL: \(error.localizedDescription)")
                        }
                        
                        // Get reference to AppDelegatesrefer
                        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                        
                        // Create a context
                        let managedContext = appDelegate.persistentContainer.viewContext
                        
                        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: Constants.kDocument.entityName)
                        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: Constants.kDocument.createDateString, ascending: false)]
                        fetchRequest.predicate = NSPredicate(format: "\(Constants.kDocument.idString) = %@", idString)
                        
                        do {
                            let documents = try managedContext.fetch(fetchRequest)
                            
                            let objectUpdate = documents.first! as! Document
                            objectUpdate.setValue(editDateString, forKey: Constants.kDocument.editDateString)
                            do {
                                try managedContext.save()
                            } catch {
                                print(error)
                            }
                        } catch {
                            print(error)
                        }
                        
                    }
                    
                }
                
            }
        }
        
    }
    
    @objc fileprivate func undoButtonTapped(_ sender: UIButton) {
        print("👆 UNDO BUTTON")
        
        canvasView.undo()
        
    }
    
    @objc fileprivate func clearButtonTapped(_ sender: UIButton) {
        print("👆 CLEAR BUTTON")
        
        canvasView.clear()
        
    }
    
    @objc fileprivate func penButtonTapped(_ sender: UIButton) {
        print("👆 PEN BUTTON")
        
        removeChildController()
        setUpPenController()
        canvasView.superview?.bringSubviewToFront(canvasView)
        subtitleLabel.text = "Canvas"
        
        undoButton.isEnabled = true
        clearButton.isEnabled = true
        
    }
    
    @objc fileprivate func markerButtonTapped(_ sender: UIButton) {
        print("👆 MARKER BUTTON")
        
        removeChildController()
        setUpMarkerController()
        canvasView.superview?.bringSubviewToFront(canvasView)
        subtitleLabel.text = "Canvas"
        
        undoButton.isEnabled = true
        clearButton.isEnabled = true
        
    }
    
    @objc fileprivate func highlightButtonTapped(_ sender: UIButton) {
        print("👆 HIGHLIGHT BUTTON")
        
        removeChildController()
        setUpHighlightController()
        canvasView.superview?.bringSubviewToFront(canvasView)
        subtitleLabel.text = "Canvas"
        
        undoButton.isEnabled = true
        clearButton.isEnabled = true
        
    }
    
    @objc fileprivate func textButtonTapped(_ sender: UIButton) {
        print("👆 TEXT BUTTON")
        
        removeChildController()
        setUpTextController()
        annotationView.superview?.bringSubviewToFront(annotationView)
        subtitleLabel.text = "Annoatation"
        
        undoButton.isEnabled = false
        clearButton.isEnabled = false
        
        let textView = TextView(frame: .zero, textContainer: nil)
        textView.textColor = .black
        textView.backgroundColor = .clear
        textView.contentMode = .center
        textView.backgroundColor = .red
        textView.delegate = self
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.isUserInteractionEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        annotationView.addSubview(textView)
        
        textView.becomeFirstResponder()
        
    }
    
    @objc fileprivate func shapesButtonTapped(_ sender: UIButton) {
        print("👆 SHAPES BUTTON")
        
        removeChildController()
        setUpShapesController()
        annotationView.superview?.bringSubviewToFront(annotationView)
        subtitleLabel.text = "Annoatation"
        
        undoButton.isEnabled = false
        clearButton.isEnabled = false
        
    }
    
    @objc fileprivate func noteButtonTapped(_ sender: UIButton) {
        print("👆 NOTE BUTTON")
        
        removeChildController()
        setUpNoteController()
        annotationView.superview?.bringSubviewToFront(annotationView)
        subtitleLabel.text = "Annoatation"
        
        undoButton.isEnabled = false
        clearButton.isEnabled = false
        
        let note = Note(date: Date(), text: "", color: .yellow, point: .zero)
        let rect = CGRect(x: 0, y: 0, width: 16, height: 16)
        let noteImageView = NoteImageView(withNote: note, frame: rect)
        noteImageView.image = UIImage(named: "notes")
        noteImageView.delegate = self
        noteImageView.tintColor = .orange
        noteImageView.isUserInteractionEnabled = true
        noteImageView.translatesAutoresizingMaskIntoConstraints = false
        
        annotationView.addSubview(noteImageView)
        
    }
    
    @objc fileprivate func stickersButtonTapped(_ sender: UIButton) {
        print("👆 STICKERS BUTTON")
        
        removeChildController()
        setUpStickersController()
        annotationView.superview?.bringSubviewToFront(annotationView)
        subtitleLabel.text = "Annoatation"
        
        undoButton.isEnabled = false
        clearButton.isEnabled = false
        
    }
    
    @objc fileprivate func signatureButtonTapped(_ sender: UIButton) {
        print("👆 SIGNATURE BUTTON")
        
        removeChildController()
        setUpSignatureController()
        annotationView.superview?.bringSubviewToFront(annotationView)
        subtitleLabel.text = "Annoatation"
        
        undoButton.isEnabled = false
        clearButton.isEnabled = false
        
    }
    
    // MARK: Helper
    
    fileprivate func removeChildController() {
        
        if self.children.count > 0 {
            for viewContoller in children {
                if viewContoller === penController {
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                    penController = nil
                } else if viewContoller === markerController {
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                    markerController = nil
                } else if viewContoller === highlightController {
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                    highlightController = nil
                } else if viewContoller === textController {
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                    textController = nil
                } else if viewContoller === shapesController {
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                    shapesController = nil
                } else if viewContoller === noteController {
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                    noteController = nil
                } else if viewContoller === stickersController {
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                    stickersController = nil
                } else if viewContoller === signatureController {
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                    signatureController = nil
                }
            }
        }
        
    }
    
    fileprivate func setUpPenController() {
        
        if penController == nil {
            // Init
            penController = PenController()
            if let penController = penController {
                penController.delegate = self
                
                // Add as a child view
                addChild(penController)
                view.addSubview(penController.view)
                penController.didMove(toParent: self)
                
                // Adjust frame and initial position
                let height = view.frame.height
                let width  = view.frame.width
                penController.view.frame = CGRect(x: 0, y: view.frame.maxY, width: width, height: height)
            }
        }
        
    }
    
    fileprivate func setUpMarkerController() {
        
        if markerController == nil {
            // Init
            markerController =  MarkerController()
            if let markerController = markerController {
                markerController.delegate = self
                
                // Add as a child view
                addChild(markerController)
                view.addSubview(markerController.view)
                markerController.didMove(toParent: self)
                
                // Adjust frame and initial position
                let height = view.frame.height
                let width  = view.frame.width
                markerController.view.frame = CGRect(x: 0, y: view.frame.maxY, width: width, height: height)
            }
        }
        
    }
    
    fileprivate func setUpHighlightController() {
        
        if highlightController == nil {
            // Init
            highlightController =  HighlightController()
            if let highlightController = highlightController {
                highlightController.delegate = self
                
                // Add as a child view
                addChild(highlightController)
                view.addSubview(highlightController.view)
                highlightController.didMove(toParent: self)
                
                // Adjust frame and initial position
                let height = view.frame.height
                let width  = view.frame.width
                highlightController.view.frame = CGRect(x: 0, y: view.frame.maxY, width: width, height: height)
            }
        }
        
    }
    
    fileprivate func setUpTextController() {
        
        if textController == nil {
            // Init
            textController = TextController()
            if let textController = textController {
                textController.delegate = self
                
                // Add as a child view
                addChild(textController)
                view.addSubview(textController.view)
                textController.didMove(toParent: self)
                
                // Adjust frame and initial position
                let height = view.frame.height
                let width = view.frame.width
                textController.view.frame = CGRect(x: 0, y: view.frame.maxY, width: width, height: height)
                
            }
        }
        
    }
    
    fileprivate func setUpShapesController() {
        
        if shapesController == nil {
            // Init
            shapesController = ShapesController()
            if let shapesController = shapesController {
                shapesController.delegate = self
                
                // Add as a child view
                addChild(shapesController)
                view.addSubview(shapesController.view)
                shapesController.didMove(toParent: self)
                
                // Adjust frame and initial position
                let height = view.frame.height
                let width  = view.frame.width
                shapesController.view.frame = CGRect(x: 0, y: view.frame.maxY, width: width, height: height)
            }
        }
        
    }
    
    fileprivate func setUpNoteController() {
        
        if noteController == nil {
            // Init
            noteController = NoteController()
            if let noteController = noteController {
                noteController.delegate = self
                
                // Add as a child view
                addChild(noteController)
                view.addSubview(noteController.view)
                noteController.didMove(toParent: self)
                
                // Adjust frame and initial position
                let height = view.frame.height
                let width  = view.frame.width
                noteController.view.frame = CGRect(x: 0, y: view.frame.maxY, width: width, height: height)
            }
        }
        
    }
    
    fileprivate func setUpStickersController() {
        
        if stickersController == nil {
            // Init
            stickersController = StickersController()
            if let stickersController = stickersController {
                stickersController.delegate = self
                
                // Add as a child view
                addChild(stickersController)
                view.addSubview(stickersController.view)
                stickersController.didMove(toParent: self)
                
                // Adjust frame and initial position
                let height = view.frame.height
                let width  = view.frame.width
                stickersController.view.frame = CGRect(x: 0, y: view.frame.maxY, width: width, height: height)
            }
        }
        
    }
    
    fileprivate func setUpSignatureController() {
        
        if signatureController == nil {
            // Init
            signatureController = SignatureController()
            if let signatureController = signatureController {
                signatureController.delegate = self
                
                // Add as a child view
                addChild(signatureController)
                view.addSubview(signatureController.view)
                signatureController.didMove(toParent: self)
                
                // Adjust frame and initial position
                let height = view.frame.height
                let width  = view.frame.width
                signatureController.view.frame = CGRect(x: 0, y: view.frame.maxY, width: width, height: height)
            }
        }
        
    }
    
    fileprivate func loadPdfDocument() {
        
        // Get reference to AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // Create a context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Prepare the request of type NSFetchRequest for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.kDocument.entityName)
        
        // Get data from CoreData only with nameString equal "No name"
        // fetchRequest.predicate = NSPredicate(format: "\(Constants.kDocument.nameString) = %@", "No name")
        // Get data sorting by "createDateString"
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: Constants.kDocument.createDateString, ascending: false)]
        
        do {
            let documents = try managedContext.fetch(fetchRequest) as! [Document]
            if documents.count > 0 {
                let document = documents.first!
                
                self.document = document
                
                if let idString = document.idString {
                    
                    let fileManager = FileManager.default
                    if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                        
                        var docURL: URL
                        if let createDateString = document.createDateString, let editDateString = document.editDateString {
                            if createDateString != editDateString {
                                docURL = documentDirectory.appendingPathComponent(idString + "edited")
                            } else {
                                docURL = documentDirectory.appendingPathComponent(idString)
                            }
                        } else {
                            docURL = documentDirectory.appendingPathComponent(idString)
                        }
                        
                        if fileManager.fileExists(atPath: docURL.path) {
                            
                            if let pdfDocument = PDFDocument(url: docURL) {
                                pdfView.document = pdfDocument
                            } else {
                                print("Error no document")
                            }
                            
                        } else {
                            print("Error load file from URL")
                        }
                        
                    }
                    
                } else {
                    print("Error no document")
                }
                
            }
        } catch {
            print("Failed")
        }
        
    }
    
    fileprivate func makeRectangleAnnotationAndSave() {
        
        guard let page = pdfView.currentPage else {return}
        // Note: in PDF page coordinate space, (0,0) is the bottom left corner of the page
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 100, height: 100))
        let inkAnnotation = PDFAnnotation(bounds: page.bounds(for: pdfView.displayBox), forType: .ink, withProperties: nil)
        inkAnnotation.add(path)
        page.addAnnotation(inkAnnotation)
        
        
        if let pdfDocument = pdfView.document {
            
            // Today date
            let today = Date()
            
            // Create date string
            let editDateFormatter = DateFormatter()
            editDateFormatter.dateFormat = "MMM d, yyyy HH:mm"
            let editDateString = editDateFormatter.string(from: today)
            
            // Get the data of PDF document
            let data = pdfDocument.dataRepresentation()
            
            // Get directory
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let documentURL = documentDirectory.appendingPathComponent(document!.idString!+"edited")
            print(documentURL)
            let urlString = documentURL.path
            print(urlString)
            
            // Save document to directory
            do {
                try data?.write(to: documentURL)
            } catch (let error) {
                print("Error save data to URL: \(error.localizedDescription)")
            }
            
            // Get reference to AppDelegatesrefer
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            // Create a context
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: Constants.kDocument.entityName)
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: Constants.kDocument.createDateString, ascending: false)]
            fetchRequest.predicate = NSPredicate(format: "\(Constants.kDocument.idString) = %@", document!.idString!)
            
            do {
                let documents = try managedContext.fetch(fetchRequest)
                
                let objectUpdate = documents.first! as! Document
                objectUpdate.setValue(editDateString, forKey: Constants.kDocument.editDateString)
                do {
                    try managedContext.save()
                } catch {
                    print(error)
                }
            } catch {
                print(error)
            }
            
        }
        
    }
    
}

extension AnnotationController: MarkerControllerDelegate {
    
    // MARK: MarkerControllerDelegate
    
    func markerParameter(color: UIColor, thinkness: CGFloat, opacity: CGFloat) {
        
        canvasView.setStrokeColor(color: color)
        canvasView.setStrokeWidth(width: Float(thinkness))
        canvasView.setAlphaValue(opacity: Float(opacity))
        
    }
    
    func cancelMarker() {
        removeChildController()
    }
    
}

extension AnnotationController: PenControllerDelegate {
    
    // MARK: MarkerControllerDelegate
    
    func penParameter(color: UIColor, thinkness: CGFloat) {
        
        canvasView.setStrokeColor(color: color)
        canvasView.setStrokeWidth(width: Float(thinkness))
        canvasView.setAlphaValue(opacity: 1)
        
    }
    
    func cancelPen() {
        removeChildController()
    }
    
}

extension AnnotationController: TextControllerDelegate {
    
    // MARK: TextControllerDelegate
    
    func textParameter(color: UIColor, backgorundColor: UIColor, size: CGFloat) {
        
    }
    
    func cancelText() {
        removeChildController()
    }
    
}

extension AnnotationController: HighlightControllerDelegate {
    
    // MARK: HighlightControllerDelegate
    
    func highlightParameter(color: UIColor, opacity: CGFloat) {
        
        canvasView.setStrokeColor(color: color)
        canvasView.setAlphaValue(opacity: Float(opacity))
        
    }
    
    func cancelHighlight() {
        removeChildController()
    }
    
}

extension AnnotationController: NoteControllerDelegate {
    
    // MARK: NoteControllerDelegate
    
    func noteParameter(note: Note?, color: UIColor) {
        
    }
    
    func cancelNote() {
        removeChildController()
    }
    
}

extension AnnotationController: StickersControllerDelegate {
    
    // MARK: StickersControllerDelegate
    
    func stickersParameter(image: UIImage) {
        
        let stickerImageView = StickerImageView(frame: .zero)
        stickerImageView.image = image
        
        annotationView.addSubview(stickerImageView)
        
        removeChildController()
        
    }
    
    func cancelStickers() {
        removeChildController()
    }
    
}

extension AnnotationController: SignatureControllerDelegate {
    
    // MARK: SignatureController
    
    func signatureParameter(signatureImage: UIImage?) {
        
        // TODO: Send UIBeziePath instad UIImage.
        
        if let signatureImage = signatureImage {
                        
            let signatureImageView = SignatureImageView(frame: .zero)
            signatureImageView.image = signatureImage
            signatureImageView.backgroundColor = .clear
            signatureImageView.translatesAutoresizingMaskIntoConstraints = false
            
            annotationView.addSubview(signatureImageView)
            
            removeChildController()
            
        }
        
    }
    
    func cancelSignature() {
        removeChildController()
    }
    
}

extension AnnotationController: ShapesControllerDelegate {
    
    func shapeesParameter(shape: Shapes, color: UIColor, width: CGFloat, opacity: CGFloat) {
        
        // TODO: After implement draw all shapes remove switch statment from this function.
        
        switch shape {
            case .line:
                let arrowView = ShapeeView(shape: .line, frame: .zero)
                annotationView.addSubview(arrowView)
                NSLayoutConstraint.activate([
                    arrowView.widthAnchor.constraint(equalToConstant: 200),
                    arrowView.heightAnchor.constraint(equalToConstant: 50)
                ])
            case .arrow:
                let arrowView = ShapeeView(shape: .arrow, frame: .zero)
                annotationView.addSubview(arrowView)
                NSLayoutConstraint.activate([
                    arrowView.widthAnchor.constraint(equalToConstant: 200),
                    arrowView.heightAnchor.constraint(equalToConstant: 50)
                ])
            case .size:
                return
            case .rectangle:
                return
            case .circle:
                return
            case .check:
                return
            case .cross:
                return
        }
        
        removeChildController()
        
    }
    
    func cancel() {
        removeChildController()
    }
    
}

extension AnnotationController: EnterTextControllerDelegate {
    
    func enteredText(text: String) {
        // TODO: Save string to selectec note or text
    }
    
}

extension AnnotationController: NoteImageViewDelegate {
    
    func noteTapped(none: Note) {
        
        let enterTextController = EnterTextController()
        enterTextController.delegate = self
        navigationController?.pushViewController(enterTextController, animated: true)
        
    }
    
}

extension AnnotationController: UITextViewDelegate {
    
    // MARK: UITextViewDelegate
    
    
    
}

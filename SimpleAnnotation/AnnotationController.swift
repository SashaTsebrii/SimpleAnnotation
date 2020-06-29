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
    
    // MARK: Prpperties
    
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
    
    fileprivate let canvasView: CanvasView = {
        let canvasView = CanvasView()
        canvasView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        canvasView.backgroundColor = .clear
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        return canvasView
    }()
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        // Set title
        title = NSLocalizedString("Annotation", comment: "")
        
        // Set background color
        view.backgroundColor = UIColor.Design.background
        
        // clearButton
        let clearButton = UIButton(frame: .zero)
        clearButton.setImage(UIImage(named: "clear"), for: .normal)
        clearButton.addTarget(self, action: #selector(clearButtonTapped(_:)), for: .touchUpInside)
        clearButton.backgroundColor = .white
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(clearButton)
        NSLayoutConstraint.activate([
            clearButton.widthAnchor.constraint(equalToConstant: 44),
            clearButton.heightAnchor.constraint(equalTo: clearButton.widthAnchor),
            clearButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            clearButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        
        // undoButton
        let undoButton = UIButton(frame: .zero)
        undoButton.setImage(UIImage(named: "undo"), for: .normal)
        undoButton.addTarget(self, action: #selector(undoButtonTapped(_:)), for: .touchUpInside)
        undoButton.backgroundColor = .white
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        
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
            toolbarContentView.widthAnchor.constraint(equalToConstant: 700),
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
        
        // Create save bar button item
        let saveButton = UIButton(frame: .zero)
        saveButton.tintColor = .white
        saveButton.setImage(UIImage(named: "save"), for: .normal)
        saveButton.addTarget(self, action: #selector(saveBarButtonTapped(_:)), for: .touchUpInside)
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = saveBarButton
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPdfDocument()
        
        /*
        guard let page = pdfView.currentPage else {return}
        // Create a rectangular path
        // Note that in PDF page coordinate space, (0,0) is the bottom left corner of the page
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 100, height: 100))
        let inkAnnotation = PDFAnnotation(bounds: page.bounds(for: pdfView.displayBox), forType: .ink, withProperties: nil)
        inkAnnotation.add(path)
        page.addAnnotation(inkAnnotation)
        */
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: Actions
    
    @objc fileprivate func saveBarButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func undoButtonTapped(_ sender: UIButton) {
        canvasView.undo()
        
        removeChildController()
        
    }
    
    @objc func clearButtonTapped(_ sender: UIButton) {
        canvasView.clear()
        
        removeChildController()
        
    }
    
    @objc fileprivate func penButtonTapped(_ sender: UIButton) {
        
        removeChildController()
        
        // Add the bottom colors view
        setUpPenController()
        
    }
    
    @objc fileprivate func markerButtonTapped(_ sender: UIButton) {
        
        removeChildController()
        
        // Add the bottom colors view
        setUpMarkerController()
        
    }
    
    // MARK: Helper
    
    func removeChildController() {
        if self.children.count > 0{
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
                }
            }
        }
    }
    
    func setUpPenController() {
        
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
    
    func setUpMarkerController() {
        
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
    
    func loadPdfDocument() {
        
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
                
                if let idString = document.idString {

                    let fileManager = FileManager.default
                    if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {

                        let docURL = documentDirectory.appendingPathComponent(idString)
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
    
}

extension AnnotationController: MarkerControllerDelegate {
    
    // MARK: MarkerControllerDelegate
    
    func markerParameter(color: UIColor, thinkness: CGFloat, opacity: CGFloat) {
        
        canvasView.setStrokeColor(color: color)
        canvasView.setStrokeWidth(width: Float(thinkness))
        
    }
    
}

extension AnnotationController: PenControllerDelegate {
    
    // MARK: MarkerControllerDelegate
    
    func markerParameter(color: UIColor, thinkness: CGFloat) {
        
        canvasView.setStrokeColor(color: color)
        canvasView.setStrokeWidth(width: Float(thinkness))
        
    }
    
}

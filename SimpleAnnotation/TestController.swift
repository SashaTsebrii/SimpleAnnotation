//
//  TestController.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 6/30/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit
import PDFKit
import CoreData

/*
class TestController: UIViewController {
    
    var bezierPath = UIBezierPath()
    var previousPoint: CGPoint?
    var isFirst = true
    
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
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(pdfView)
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                        
                        let docURL = documentDirectory.appendingPathComponent(idString+"edited")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
    }
    
}

extension TestController: UIGestureRecognizerDelegate {
    
//    override func touchesBegan(touchesSet: Set<UITouch>, withEvent event: UIEvent?) {
//        let location = touchesSet.first!.locationInView(self)
//        bezierPath.removeAllPoints()
//        bezierPath.moveToPoint(location)
//        prevPoint = location
//    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self.view) {
            bezierPath.removeAllPoints()
            bezierPath.move(to: location)
            previousPoint = location
        }
    }
    
    

//    override func touchesMoved(touchesSet: Set<UITouch>, withEvent event: UIEvent?) {
//        let location = touchesSet.first!.locationInView(self)
//
//        if let prevPoint = prevPoint {
//            let midPoint = CGPoint(
//                x: (location.x + prevPoint.x) / 2,
//                y: (location.y + prevPoint.y) / 2,
//            )
//            if isFirst {
//                bezierPath.addLineToPoint(midPoint)
//            else {
//                bezierPath.addQuadCurveToPoint(midPoint, controlPoint: prevPoint)
//            }
//            isFirst = false
//        }
//        prevPoint = location
//    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self.view) {
            if let previousPoint = previousPoint {
                let midPoint = CGPoint(x: (location.x + previousPoint.x) / 2, y: (location.y + previousPoint.y) / 2)
                if isFirst {
                    bezierPath.addLine(to: midPoint)
                } else {
                    bezierPath.addQuadCurve(to: midPoint, controlPoint: previousPoint)
                }
                isFirst = false
            }
            previousPoint = location
        }
    }
    
//    override func touchesEnded(touchesSet: Set<UITouch>, withEvent event: UIEvent?) {
//        let location = touchesSet.first!.locationInView(self)
//        bezierPath.addLineToPoint(location)
//    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self.view) {
            bezierPath.addLine(to: location)
        }
    }
        
}
*/

/*
class TestController: UIViewController {
    
    var signingPath: UIBezierPath!
    var lastPoint: CGPoint = .zero
    var annotationAdded: Bool = false
    var currentAnnotation = PDFAnnotation()
    
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
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(pdfView)
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                        
                        let docURL = documentDirectory.appendingPathComponent(idString+"edited")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pdfView.isUserInteractionEnabled = false
        
    }
    
}

extension TestController: UIGestureRecognizerDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: pdfView)
            signingPath = UIBezierPath()
            signingPath.move(to: pdfView.convert(position, to: pdfView.page(for: position, nearest: true)!))
            annotationAdded = false
            UIGraphicsBeginImageContext(pdfView.bounds.size)
            lastPoint = pdfView.convert(position, to: pdfView.page(for: position, nearest: true)!)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: pdfView)
            let convertedPoint = pdfView.convert(position, to: pdfView.page(for: position, nearest: true)!)
            let page = pdfView.page(for: position, nearest: true)!
            signingPath.addLine(to: convertedPoint)
            let rect = signingPath.bounds
            
            if (annotationAdded) {
                pdfView.document?.page(at: 0)?.removeAnnotation(currentAnnotation)
                currentAnnotation = PDFAnnotation(bounds: rect, forType: .ink, withProperties: nil)
                
                var signingPathCentered = UIBezierPath()
                signingPathCentered.cgPath = signingPath.cgPath
                signingPathCentered.move(to: rect.origin)//moveCenter(to: rect.center)
                currentAnnotation.add(signingPathCentered)
                pdfView.document?.page(at: 0)?.addAnnotation(currentAnnotation)
                
            } else {
                lastPoint = pdfView.convert(position, to: pdfView.page(for: position, nearest: true)!)
                annotationAdded = true
                currentAnnotation = PDFAnnotation(bounds: rect, forType: .ink, withProperties: nil)
                currentAnnotation.add(signingPath)
                pdfView.document?.page(at: 0)?.addAnnotation(currentAnnotation)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: pdfView)
            signingPath.addLine(to: pdfView.convert(position, to: pdfView.page(for: position, nearest: true)!))
            
            pdfView.document?.page(at: 0)?.removeAnnotation(currentAnnotation)
            
            let rect = signingPath.bounds
            let annotation = PDFAnnotation(bounds: rect, forType: .ink, withProperties: nil)
            annotation.color = UIColor(netHex: 0x284283)
            signingPath.move(to: rect.origin)//moveCenter(to: rect.center)
            annotation.add(signingPath)
            pdfView.document?.page(at: 0)?.addAnnotation(annotation)
        }
    }
    
}
*/

class TestController: UIViewController {
    
    fileprivate let canvasView: SimpleCanvasView = {
        let canvasView = SimpleCanvasView(frame: .zero)
        canvasView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        return canvasView
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
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(pdfView)
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        pdfView.addSubview(canvasView)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                        
                        let docURL = documentDirectory.appendingPathComponent(idString)// + "edited")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pdfView.isUserInteractionEnabled = false
        
    }
    
}

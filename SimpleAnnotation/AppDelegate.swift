//
//  AppDelegate.swift
//  SimpleAnnotation
//
//  Created by Aleksandr Tsebrii on 6/29/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit
import CoreData
import PDFKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "SimpleAnnotation")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: Helper
    
    fileprivate func createPdfDocument() {
        
        if let path = Bundle.main.path(forResource: "sample", ofType: "pdf") {
            if let pdfDocument = PDFDocument(url: URL(fileURLWithPath: path)) {
                
                // Today date
                let today = Date()
                
                // Create date string
                let createDateFormatter = DateFormatter()
                createDateFormatter.dateFormat = "MMM d, yyyy HH:mm"
                let createDateString = createDateFormatter.string(from: today)
                
                // Id from current date string
                let idFormatter = DateFormatter()
                idFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let idString = idFormatter.string(from: today)
                
                // Get the data of PDF document
                let data = pdfDocument.dataRepresentation()
                
                // Get directory
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let documentURL = documentDirectory.appendingPathComponent(idString)
                print(documentURL)
                let urlString = documentURL.path
                print(urlString)
                
                // Save document to directory
                do {
                    try data?.write(to: documentURL)
                } catch (let error) {
                    print("Error save data to URL: \(error.localizedDescription)")
                }
                
                // Create a context
                let managedContext = persistentContainer.viewContext
                
                // Create an entity and new document records
                let documentEntity = NSEntityDescription.entity(forEntityName: Constants.kDocument.entityName, in: managedContext)!
                
                // Final add some data to newly created entity for each keys
                let document = NSManagedObject(entity: documentEntity, insertInto: managedContext)
                document.setValue("\(idString)", forKeyPath: Constants.kDocument.idString)
                document.setValue(NSLocalizedString("No name", comment: ""), forKey: Constants.kDocument.nameString)
                document.setValue("\(createDateString)", forKey: Constants.kDocument.createDateString)
                document.setValue("\(createDateString)", forKey: Constants.kDocument.editDateString)
                
                // After set all the values, save them inside the CoreData
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                
            }
        }
        
    }
    
}

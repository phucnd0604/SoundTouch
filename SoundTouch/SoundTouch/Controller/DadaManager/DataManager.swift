//
//  DataManager.swift
//  SoundTouch
//
//  Created by phuc nguyen on 4/24/15.
//  Copyright (c) 2015 phuc nguyen. All rights reserved.
//

import Foundation
import CoreData
let kDatamanagerModelname = "SoundTouch"
let kDataBaseName = "data.sqlite"
class DataManager {
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        println(urls)
        return urls[urls.count-1] as! NSURL
        }()
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.objectModel!)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(kDataBaseName)
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        var options = [NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true]
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options, error: &error) == nil {
            coordinator = nil
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    lazy var mainObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    lazy var objectModel: NSManagedObjectModel? = {
        let modelURL = NSBundle.mainBundle().URLForResource(kDatamanagerModelname, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    static let shareInstance = DataManager()
    
    func saveContext () {
        if let moc = self.mainObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    // init data base
    func initDataBase() {
        let categoriesFilePath = NSBundle.mainBundle().pathForResource("Categorirs", ofType: "json")
        let data = NSData(contentsOfFile: categoriesFilePath!)
        let json = JSON(data: data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        let result = insertCategories(json)
        if result.0 {
            println("Init OK")
            let dataFilePath = NSBundle.mainBundle().pathForResource("db", ofType: "json")
            let datax = NSData(contentsOfFile: dataFilePath!)
            var error: NSError?
            let jsonx = JSON(data: datax!, options: NSJSONReadingOptions.AllowFragments, error: &error)
            let result = insertModel(jsonx)
            if result.0 {
                println("finish")
            } else {
                println(result.1)
            }
        }
    }
    
    func insertCategories(categories: JSON) -> (Bool, NSError?) {
        var count = 0
        let context = DataManager.shareInstance.mainObjectContext
        if categories.count <= 0 {
            return (false, nil)
        } else {
            for (index: String, subJson: JSON) in categories {
                if Categories.getCategoryByName(subJson.string) == nil {
                    let c = NSEntityDescription.insertNewObjectForEntityForName(kCategoriesModelName, inManagedObjectContext: context!) as! Categories
                    c.name = subJson.string!
                    count++
                }
            }
        }
        var error: NSError?
        return (context!.save(nil), error)
    }
    func insertModel(models: JSON) -> (Bool, NSError?) {
        var count = 0
        let context = DataManager.shareInstance.mainObjectContext
        if models.count <= 0  {
            return (false,NSError(domain: "Error insert 0 object", code: 9191, userInfo: nil))
        } else {
            for (index: String, subJson: JSON) in models {
                if Model.getModelByName(subJson["Name"].string) == nil {
                    if let name = subJson["Name"].string,
                        category = subJson["Category"].string,
                        soundname = subJson["SoundName"].string,
                        imageName = subJson["ImageName"].string {
                            let c = NSEntityDescription.insertNewObjectForEntityForName(kModel, inManagedObjectContext: context!) as! Model
                            c.name = name
                            c.imageName = imageName
                            c.soundName = soundname
                            if let category = Categories.getCategoryByName(category) {
                                category.addModelsToCategory(c)
                                count++
                            }
                    }
                }
            }
        }
        println("inser:\(count) models")
        var error: NSError?
        return (context!.save(&error), error)
    }
}
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
        if let json = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? NSDictionary {
            let categories = json["categories"] as! NSArray
            let result = insertCategories(categories)
            if result.0 {
                println("Init OK")
                let dataFilePath = NSBundle.mainBundle().pathForResource("data", ofType: "json")
                let datax = NSData(contentsOfFile: dataFilePath!)
                if let jsonx = NSJSONSerialization.JSONObjectWithData(datax!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? NSDictionary {
                    let array = jsonx["data"] as! NSArray
                    let result = insertModel(array)
                    if result.0 {
                        println("finish")
                    } else {
                        println(result.1)
                    }
                }
            }
        }
    }
    
    func insertCategories(categories: NSArray) -> (Bool, NSError?) {
        var count = 0
        let context = DataManager.shareInstance.mainObjectContext
        if categories.count <= 0 {
            return (false, nil)
        } else {
            for aName in categories {
                if Categories.getCategoryByName(aName as? String) == nil {
                    let c = NSEntityDescription.insertNewObjectForEntityForName(kCategoriesModelName, inManagedObjectContext: context!) as! Categories
                    c.name = aName as! String
                    count++
                }
            }
        }
        var error: NSError?
        return (context!.save(nil), error)
    }
    func insertModel(models: NSArray) -> (Bool, NSError?) {
        var count = 0
        let context = DataManager.shareInstance.mainObjectContext
        if models.count <= 0  {
            return (false,nil)
        } else {
            for aName in models {
                let dict = aName as! NSDictionary
                if Model.getModelByName(dict["name"] as? String) == nil {
                    if let name = dict["name"] as? String,
                        category = dict["category"] as? String,
                        soundname = dict["soundName"] as? String,
                        imageName = dict["imageName"] as? String {
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
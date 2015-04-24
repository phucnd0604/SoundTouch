//
//  Model.swift
//  SoundTouch
//
//  Created by phuc nguyen on 4/24/15.
//  Copyright (c) 2015 phuc nguyen. All rights reserved.
//

import Foundation
import CoreData
let kModel = "Model"
@objc(Model)
class Model: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var imageName: String
    @NSManaged var soundName: String
    @NSManaged var category: Categories
}

// MARK: fetch entity
extension Model {
    class func getModelByName(aName: String?) -> Model? {
        let context = DataManager.shareInstance.mainObjectContext
        if aName == nil {
            return nil
        }
        let fetchRequest = NSFetchRequest(entityName: kModel)
        let predicate = NSPredicate(format: "name = %@", aName!)
        fetchRequest.predicate = predicate
        let result = context?.executeFetchRequest(fetchRequest, error: nil)
        if result?.count > 0 {
            return result?.last as? Model
        } else {
            return nil
        }
    }
    class func getModelByCategory(category: Categories?) -> Array<Model>? {
        let context = DataManager.shareInstance.mainObjectContext
        if category == nil { return nil}
        let fetchRequest = NSFetchRequest(entityName: kModel)
        let predicate = NSPredicate(format: "category.name = %@", category!.name)
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sort]
        let result = context?.executeFetchRequest(fetchRequest, error: nil) as? Array<Model>
        if result?.count > 0 {
            return result
        } else {
            return nil
        }
    }
}
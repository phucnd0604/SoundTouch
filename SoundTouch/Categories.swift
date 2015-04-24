//
//  Categories.swift
//  SoundTouch
//
//  Created by phuc nguyen on 4/24/15.
//  Copyright (c) 2015 phuc nguyen. All rights reserved.
//

import Foundation
import CoreData

let kCategoriesModelName = "Categories"
@objc(Categories)
class Categories: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var models: NSSet
    
    func addModelsToCategory(model: Model) {
        var zmodels = self.mutableSetValueForKey("models")
        zmodels.addObject(model)
    }
}
// MARK: fetch entity
extension Categories {
    class func getCategoryByName(aName: String?) -> Categories? {
        let context = DataManager.shareInstance.mainObjectContext
        if aName == nil {
            return nil
        }
        let fetchRequest = NSFetchRequest(entityName: kCategoriesModelName)
        let predicate = NSPredicate(format: "name = %@", aName!)
        fetchRequest.predicate = predicate
        let result = context?.executeFetchRequest(fetchRequest, error: nil)
        if result?.count > 0 {
            return result?.last as? Categories
        } else {
            return nil
        }
    }
    
    class func getAllCategory() -> Array<Categories>? {
        let context = DataManager.shareInstance.mainObjectContext
        let fetchRequest = NSFetchRequest(entityName: kModel)
        let result = context?.executeFetchRequest(fetchRequest, error: nil) as? Array<Categories>
        if result?.count > 0 {
            return result
        } else {
            return nil
        }
    }
}
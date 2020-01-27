//
//  CoreDataHandler.swift
//  CallEntry
//
//  Created by HMSPL on 25/02/19.
//  Copyright © 2019 Gowtham. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHandler: NSObject {

    static let sharedInstance = CoreDataHandler()

    private override init() {
        super.init()
    }
    func getEntity(entityName: String ,context: NSManagedObjectContext? = nil) -> NSManagedObject {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = context ?? appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)

        return NSManagedObject(entity: entity!, insertInto: managedContext)
    }

    func saveEntityDetails( entity:NSManagedObject, data:String, key:String ) {

        entity.setValue(data, forKey: key)
        do {
            try entity.managedObjectContext?.save()
        } catch let error as NSError {
            print(error)
        }
    }

    func saveEntity( entity:NSManagedObject ) {

        do {
            try entity.managedObjectContext?.save()

            entity.managedObjectContext?.parent?.perform {
                do {
                    try entity.managedObjectContext?.parent?.save()
                }catch let error as NSError {
                    print("Parent error : \(error)")
                }
            }
        } catch let error as NSError {
            print(error)
        }
    }


    func saveContext(context: NSManagedObjectContext? = nil) {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = context ?? appDelegate.persistentContainer.viewContext
        do {
            
            try managedContext.save()
            print("Save Success")
            managedContext.parent?.perform {
                do {
                    try managedContext.parent?.save()
                }catch let error as NSError {
                    print("Parent error : \(error)")
                }
            }
        } catch let error as NSError {
            print(error)
        }


    }

    func updateEntityDetails(  entityIndex:Int, entity:NSManagedObject, dataArray:[Any], keyArray:[String] ) {

        for index in 0...dataArray.count - 1 {
            entity.setValue(dataArray[index], forKey: keyArray[index])
        }
        do {
            try entity.managedObjectContext?.save()

        } catch let error as NSError {
            print(error)
        }
    }

    func updateEntity(  entityIndex:Int, entity:NSManagedObject, data:AnyObject, key:String ) {

        entity.setValue(data, forKey: key)

        do {
            try entity.managedObjectContext?.save()
        } catch let error as NSError {
            print(error)
        }
    }

    func fetchEntityDetails( entityName: String ,fetchPredicate : NSPredicate?,sortDescriptor: [NSSortDescriptor]?, context : NSManagedObjectContext? = nil) -> [NSManagedObject] {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = context ?? appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = sortDescriptor!
        }
        fetchRequest.predicate = fetchPredicate

        do {
            return try managedContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print(error)
            let entity : [NSManagedObject] = []
            return entity
        }
    }

    func delete(entityName: String ,fetchPredicate : NSPredicate? = nil, context : NSManagedObjectContext? = nil) {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = context ?? appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        fetchRequest.predicate = fetchPredicate

        if let result = try? managedContext.fetch(fetchRequest) as! [NSManagedObject] {
            for object in result {
                managedContext.delete(object)
            }
        }

        saveContext(context: managedContext)

    }

    func deleteDataAtIndex(index:Int,  entity:[NSManagedObject]) {
        entity[index].managedObjectContext?.delete(entity[index])
        do {
            try entity[index].managedObjectContext?.save()
        } catch let error as NSError {
            print(error)
        }
    }

    func deleteAllData(entity : [NSManagedObject]) {

        for index in entity {
            index.managedObjectContext?.delete(index)
        }

        do {
            try entity.first?.managedObjectContext?.save()
        } catch let error as NSError {
            print(error)
        }
    }
}

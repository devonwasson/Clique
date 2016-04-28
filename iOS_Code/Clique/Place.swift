//
//  Place.swift
//  Clique
//
//  Created by Li Li on 4/22/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//

import CoreData

class Place{
    var latitude: Double
    var longitude: Double
    var name: String
    var radius: Double
    var objectId: String
    
    init() {
        latitude = 0
        longitude = 0
        name = ""
        radius = 0
        objectId = ""
    }
    
    func saveToCoreData() -> Bool{
        if name == "" || objectId == "" {
            print("one of the fields is empty!")
            return false
        }
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Place", inManagedObjectContext:managedContext)
        let place = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        place.setValue(objectId, forKey: "objectId")
        place.setValue(latitude, forKey: "latitude")
        place.setValue(longitude, forKey: "longitude")
        place.setValue(name, forKey: "name")
        place.setValue(radius, forKey: "radius")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
    func isSaved() -> Bool {
        let place = Place.getPlaceFromCoreDataById(objectId)
        if place == nil {
            return true
        } else {
            return false
        }
    }
    
    class func getPlaceFromCoreDataById(placeId: String) -> Place?{
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Place")
        fetchRequest.predicate = NSPredicate(format: "objectId == %@", placeId)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            let mPlace = results[0]
            let place = Place()
            place.objectId = mPlace.valueForKey("objectId") as! String
            place.name = mPlace.valueForKey("name") as! String
            place.latitude = mPlace.valueForKey("latitude") as! Double
            place.longitude = mPlace.valueForKey("longitude") as! Double
            place.radius = mPlace.valueForKey("radius") as! Double
            return place
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return nil
        }
        
    }
    
    class func coreDataExists() -> Bool {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Place")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            if (results.count > 0) {
                return true
            } else {
                return false
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return false
        }   
    }
    
    class func getAllPlacesFromCoreData() -> [Place] {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Place")
        
        var results = [Place]()
        do {
            let places = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            for mPlace in places {
                let place = Place()
                place.objectId = mPlace.valueForKey("objectId") as! String
                place.name = mPlace.valueForKey("name") as! String
                place.latitude = mPlace.valueForKey("latitude") as! Double
                place.longitude = mPlace.valueForKey("longitude") as! Double
                place.radius = mPlace.valueForKey("radius") as! Double
                results += [place]
            }
            return results
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return results
        }

    }
    
    

}

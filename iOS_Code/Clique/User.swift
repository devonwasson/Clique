//
//  User.swift
//  Clique
//
//  Created by Li Li on 4/21/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//

import Foundation
import ParseUI
import CoreData

class User {
    var objectId: String
    var gender: String
    var bio: String
    var realName: String
    var userName: String
    var email: String
    
    init() {
        objectId = ""
        gender = ""
        bio = ""
        realName = ""
        userName = ""
        email = ""
    }
    
    init(objectId: String, gender: String, bio: String, realName: String, userName: String, email: String) {
        self.objectId = objectId
        self.gender = gender
        self.bio = bio
        self.realName = realName
        self.userName = userName
        self.email = email
    }
    
    func saveToCoreData() -> Bool{
        if objectId == "" || gender == "" || bio == "" || realName == "" || userName == "" || email == "" {
            print("one of the fields is empty string!")
            return false
        }
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("User", inManagedObjectContext:managedContext)
        let user = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        user.setValue(objectId, forKey: "objectId")
        user.setValue(gender, forKey: "gender")
        user.setValue(bio, forKey: "bio")
        user.setValue(realName, forKey: "realName")
        user.setValue(userName, forKey: "userName")
        user.setValue(email, forKey: "email")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
    class func getUserFromCoreDataById(userId: String) -> User?{
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "objectId == %@", userId)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            let mUser = results[0]
            let user = User()
            user.objectId = mUser.valueForKey("objectId") as! String
            user.gender = mUser.valueForKey("gender") as! String
            user.bio = mUser.valueForKey("bio") as! String
            user.realName = mUser.valueForKey("realName") as! String
            user.userName = mUser.valueForKey("userName") as! String
            user.email = mUser.valueForKey("email") as! String
            return user
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return nil
        }
        
    }
    

}

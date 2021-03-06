//
//  Message.swift
//  Clique
//
//  Created by Li Li on 4/26/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//

import CoreData

class Message {
    var text: String
    var senderUserName: String
    var senderRealName: String
    var senderId: String
    var time: NSNumber
    var channel: String
    
    init() {
        text = ""
        senderUserName = ""
        senderRealName = ""
        senderId = ""
        time = 0
        channel = ""
    }
    
    func saveToCoreData() -> Bool{
        print("saveToCoreData()")
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Message", inManagedObjectContext:managedContext)
        let message = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        message.setValue(senderId, forKey: "senderId")
        message.setValue(senderUserName, forKey: "senderUserName")
        message.setValue(senderRealName, forKey: "senderRealName")
        message.setValue(text, forKey: "text")
        message.setValue(time, forKey: "time")
        message.setValue(channel, forKey: "channel")
        print(channel)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
//    func saveToCoreData(connection: Connection) -> Bool{
//        print("saveToCoreData()")
//        let appDelegate =
//            UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        let managedContext = appDelegate.managedObjectContext
//        let entity =  NSEntityDescription.entityForName("Message", inManagedObjectContext:managedContext)
//        let message = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
//        
//        message.setValue(senderId, forKey: "senderId")
//        message.setValue(senderUserName, forKey: "senderUserName")
//        message.setValue(senderRealName, forKey: "senderRealName")
//        message.setValue(text, forKey: "text")
//        message.setValue(time, forKey: "time")
//        message.setValue(channel, forKey: "channel")
//        print(channel)
//        
//        do {
//            try managedContext.save()
//        } catch let error as NSError {
//            print("Could not save \(error), \(error.userInfo)")
//            return false
//        }
//        return true
//    }
    
    
    class func getAllMessagesFromCoreData() -> [Message] {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Message")
        
        var results = [Message]()
        do {
            let messages = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            for message in messages {
                let newMessage = Message()
                newMessage.senderId = message.valueForKey("senderId") as! String
                newMessage.senderUserName = message.valueForKey("senderUserName") as! String
                newMessage.senderRealName = message.valueForKey("senderRealName") as! String
                newMessage.text = message.valueForKey("text") as! String
                newMessage.time = message.valueForKey("time") as! NSNumber
                results += [newMessage]
            }
            return results
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return results
        }
    }
    
    class func getAllMessagesFromCoreData(connection : Connection) -> [Message] {
        print("getAllMessagesFromCoreData()")
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        var channel = "channel1"
        if connection.realUserName > currentUserRealName{
            channel = connection.realUserName + "_" + currentUserRealName
        }
        else{
            channel = currentUserRealName + "_" + connection.realUserName
        }
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Message")
        //fetchRequest.predicate = NSPredicate(format: "channel == %@", channel)
        
        var results = [Message]()
        do {
            let messages = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            for message in messages {
                if message.valueForKey("channel") as! String == channel{
                    
                    print(message.valueForKey("text"))
                    let newMessage = Message()
                    newMessage.senderId = message.valueForKey("senderId") as! String
                    newMessage.senderUserName = message.valueForKey("senderUserName") as! String
                    newMessage.senderRealName = message.valueForKey("senderRealName") as! String
                    newMessage.text = message.valueForKey("text") as! String
                    newMessage.time = message.valueForKey("time") as! NSNumber
                    results += [newMessage]
                    
                }
            }
            return results
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return results
        }
    }
    
    
}

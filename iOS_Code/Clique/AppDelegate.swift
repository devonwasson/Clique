//
//  AppDelegate.swift
//  Clique
//
//  Created by Kyle Raudensky on 4/4/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import PubNub



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, PNObjectEventListener, PubNubMessageDelegate{

    var window: UIWindow?
    var locationManager = CLLocationManager()
    var client: PubNub?
    var channels = ["channel1","channel2"]

    
    // For demo purposes the initialization is done in the init function so that
    // the PubNub client is instantiated before it is used.
    override init() {
        let config = PNConfiguration(publishKey: "pub-c-4f63ba74-0331-428d-81a0-d02bfd4bed74", subscribeKey: "sub-c-4c6c0076-0b51-11e6-a5b5-0619f8945a4f")
        client = PubNub.clientWithConfiguration(config)
        super.init()
        client?.addListener(self)
        self.client?.subscribeToChannels(channels, withPresence: false)
    }
    
    func client(client: PubNub, didReceiveMessage message: PNMessageResult) {
        if message.data.actualChannel == nil {
            if (message.data.subscribedChannel! == "channel1") {
                let messageObject = Message()
                messageObject.time = message.data.timetoken
                let dict = message.data.message as! NSDictionary
                messageObject.senderId = dict.objectForKey("senderId") as! String
                messageObject.senderUserName = dict.objectForKey("senderUserName") as! String
                messageObject.senderRealName = dict.objectForKey("senderRealName") as! String
                messageObject.text = dict.objectForKey("text") as! String
                messageObject.saveToCoreData()
                notify()	
            } else {
                print("message has been received on channel group")
            }
            // save to coredata
            
        } else {
            print("actual channel is nil")
        }
    }
    
    func notify() {
        NSNotificationCenter.defaultCenter().postNotificationName(mySpecialNotificationKey, object: self)
    }
    
    func sendMessage(message: String) {
        var messageToSent = Dictionary<String, String>()
        messageToSent["senderId"] = currentUserId
        messageToSent["senderUserName"] = currentUserName
        messageToSent["senderRealName"] = currentUserRealName
        messageToSent["text"] = message
        self.client?.publish(messageToSent, toChannel: "channel1", compressed: false, withCompletion: {
            (status) -> Void in
            print("Message sent: " + message)
        })
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //Initialize Parse
        let configuration = ParseClientConfiguration {
            $0.applicationId = "hciclique"
            $0.server = "http://li-ubuntu.cloudapp.net:1337/parse"
        }
        Parse.initializeWithConfiguration(configuration)
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        UITabBar.appearance().tintColor = UIColor(red: 102/255.0, green: 204/255.0, blue: 255/255.0, alpha: 1.0)
        UITabBar.appearance().backgroundColor = UIColor.lightGrayColor()
        UITabBar.appearance().layer.borderWidth = 1.0
        //UITabBar.appearance().layer.borderColor
        
        
        
        let fetchRequest = NSFetchRequest(entityName: "Place")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let coordinator = managedContext.persistentStoreCoordinator!
        
        do {
            try coordinator.executeRequest(deleteRequest, withContext: managedContext)
        } catch _ as NSError {
            print("Could not delete GeofenceEnterTime data")
        }
        
        
        
        if (!Place.coreDataExists()) {
            ParseFetcher.getAndSaveAllGeoFences() {
                (places: [Place]) in
                print("got and saved all places")
            }
        }
        
//        UINavigationBar.appearance().backgroundColor = UIColor(red: 119/255.0, green: 190/255.0, blue: 210/225.0, alpha: 1.0)
        UINavigationBar.appearance().opaque = true


        // Override point for customization after application launch.
        //Hello
        return true
    }
    


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "uk.co.plymouthsoftware.core_data" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("appCoreDataModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Clique.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    func clearGeofenceEnterTime() {
        let fetchRequest = NSFetchRequest(entityName: "GeofenceEnterTime")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let coordinator = managedContext.persistentStoreCoordinator!
        
        do {
            try coordinator.executeRequest(deleteRequest, withContext: managedContext)
        } catch _ as NSError {
            print("Could not delete GeofenceEnterTime data")
        }
    }
    
    func saveGeofenceEnterTime(time: Double) {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("GeofenceEnterTime", inManagedObjectContext:managedContext)
        let geofenceEnterTime = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        geofenceEnterTime.setValue(time, forKey: "enterTime")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func getGeofenceEnterTime() -> Double{
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "GeofenceEnterTime")
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            let mTime = results[0]
            return mTime.valueForKey("enterTime") as! Double
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return 0
        }

    }
    
    // MARK: Goefencing delegates
    
    func handleRegionEvent(region: CLRegion!, type: String) {
        if type == "Enter" {
            print("Geofence entered!")
            
            let time = Double(NSDate().timeIntervalSince1970 * 1000)
            let geotifications = Geotification.loadAllGeofitications()
            for geotification in geotifications {
                if geotification.id == region.identifier {
                    clearGeofenceEnterTime()
                    saveGeofenceEnterTime(time)
                    return
                }
            }
            print("Current time" + String(time) + ": Cannot find geotification")
            
        } else if type == "Exit" {
            print("Geofence exit!")
            let exitTime = Double(NSDate().timeIntervalSince1970 * 1000)
            let enterTime = getGeofenceEnterTime()
            ParseFetcher.addNewTimePair("vJWd1CVvex", placeID: region.identifier, startTime: String(enterTime), endTime: String(exitTime))
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleRegionEvent(region, type: "Enter")
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleRegionEvent(region, type: "Exit")
        }
    }


}


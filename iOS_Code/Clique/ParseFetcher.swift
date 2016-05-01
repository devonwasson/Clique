//
//  ParseFetcher.swift
//  Clique
//
//  Created by Li Li.
//  Copyright © 2016 BuckMe. All rights reserved.
//

import Foundation
import CoreData

class ParseFetcher {
    
    static var globalUserID = "vJWd1CVvex"
    ///
    /// Make call to Parse to get all geoFences and load them into CoreData
    ///
    class func getAndSaveAllGeoFences(completion: (places: [Place]) -> Void) {
        PFCloud.callFunctionInBackground("getAllGeoFences", withParameters: nil, block:
            {
                (results: AnyObject?, error: NSError?) -> Void in
                var places = [Place]()
                if (error == nil) {
                    print("Sucessfully received all geoFence results")
                    let locations = results as! [PFObject]
                    
                    for location in locations {
                        let place = Place()
                        place.name = location.objectForKey("name") as! String
                        place.objectId = location.objectId!
                        let longitudeLatitude = location.objectForKey("location") as! PFGeoPoint
                        
                        place.latitude = longitudeLatitude.latitude
                        place.longitude = longitudeLatitude.longitude
                        place.radius = location.objectForKey("radius") as! Double
                        
                        // this will save the place to CoreData
                        if (!place.isSaved()) {
                            place.saveToCoreData()
                        }
                        
                        print("finished saving location data")
                        places += [place]
                    }
                    
                    completion(places: places)
                }
                else {
                    //error occurred
                    print("Error retrieving geofences")
                    completion(places: places)
                }
        })

    }
    
    
    ///
    /// Make call to Parse to get overlapping users for the main user
    ///
    class func getOverlappingUsersWithInformation(userID: String, completion: (connections: [Connection]) -> Void) {
        PFCloud.callFunctionInBackground("getOverlappingUsersWithInformation", withParameters: ["userId": userID], block:
            {
                (results: AnyObject?, error: NSError?) -> Void in
                if (error == nil) {
                    print("Successfully retrieved overlapping users")
                    
                    var connections = [Connection]()
                    let userTimePairs = results as! NSArray
                    //print(userTimePairs)
                    
                    let getLocationGroup = dispatch_group_create()
                    for userTimePair in userTimePairs {
                        let connection: Connection = Connection()
                        connections += [connection]
                        // get user information
                        let userId = userTimePair.objectForKey("userId") as! String
                        let userName = userTimePair.objectForKey("userName") as! String
                        let realUserName = userTimePair.objectForKey("realName") as! String
                        let bio = userTimePair.objectForKey("bio") as! String
                        let email = userTimePair.objectForKey("email") as! String
                        let gender = userTimePair.objectForKey("gender") as! String
                        //print((userTimePair.objectForKey("profilePic") as! PFFile?)?.url
                        let profilePic = userTimePair.objectForKey("profilePic") as! PFFile?
                        
                        connection.userId = userId
                        connection.userName = userName
                        connection.realUserName = realUserName
                        connection.bio = bio
                        connection.email = email
                        connection.gender = gender
                        connection.profilePicture = profilePic
                        
                        
                        // get timepairs information
                        let timePairs = userTimePair.objectForKey("placesTimePairs") as! NSDictionary
                        
                        for locationId in timePairs.allKeys as! [String] {
                            // get location name by id
                            dispatch_group_enter(getLocationGroup)
                            self.getLocationById(locationId) {
                                (unWrappedLocation: PFObject?) in
                                if unWrappedLocation != nil {
                                    let location = unWrappedLocation!
                                    // Construct a PlaceTime object
                                    let placeTime: Connection.PlaceTime = Connection.PlaceTime()
                                    placeTime.placeId = locationId
                                    placeTime.placeName = location.objectForKey("name") as! String
                                    
                                    
                                    location.objectForKey("name") as! String
                                    
                                    var totalTimeInSec:Double = 0
                                    var lastSeenTime: Double = 0
                                    for startEndTime in (timePairs.objectForKey(locationId) as! NSArray) {
                                        let startTime = startEndTime.objectForKey("startTime") as! NSDate
                                        let endTime = startEndTime.objectForKey("endTime") as! NSDate
                                        let timeIntervalInSec = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
                                        totalTimeInSec += timeIntervalInSec
                                        placeTime.timePairs.append((startTime: startTime.timeIntervalSince1970, endTime: endTime.timeIntervalSince1970))
                                        if endTime.timeIntervalSince1970 > lastSeenTime {
                                            lastSeenTime = endTime.timeIntervalSince1970
                                        }
                                    }
                                    
                                    placeTime.totalTime = Int(totalTimeInSec)
                                    placeTime.lastSeenTime = lastSeenTime
                                    
                                    
                                    connection.placesTimePairs += [placeTime]
                                    //print("getLocationById done")
                                    dispatch_group_leave(getLocationGroup)
                                } else {
                                    dispatch_group_leave(getLocationGroup) // leave the dispatch group and do nothing
                                }
                            }
                            
                        }
                    }
                    
                    dispatch_group_notify(getLocationGroup, GlobalMainQueue) {
                        for connection in connections {
                            connection.computeLastPlaceSeen()
                            connection.computeTotalTimeInSec()
                        }
                        
                        completion(connections: connections)
                        print("finish function")
                    }
                    
                }
                else {
                    //callFunctionInBackground("getOverlappingUsersWithInformation") error
                    dispatch_async(GlobalMainQueue) {
                        completion(connections: [])
                    }
                    print("Error retrieving overlapping users")
                }
        })
    }
    
    
    class func getLocationById(locationId: String, completion: (location: PFObject?) -> Void) {
        let query = PFQuery(className:"Place")
        query.getObjectInBackgroundWithId(locationId) {
            (locationObject: PFObject?, error: NSError?) -> Void in
            if error == nil && locationObject != nil {
                completion(location: locationObject!)
            } else {
                completion(location: nil)
                print(error)
            }
        }
    }
    
    ///
    /// Make call to Parse to return overlapping places for user with given
    /// userID
    ///
    class func getOverlappingPlaces(userID: String, completion: (placeConnections: [PlaceConnection]) -> Void) {
        PFCloud.callFunctionInBackground("getOverlappingPlaces", withParameters: ["userId": userID], block:
            {
                (results: AnyObject?, error: NSError?) -> Void in
                if (error == nil) {
                    print("Successfully retrieved overlapping users")
                    var placeConnections = [PlaceConnection]()
                    
                    let placesTimePairs = results as! NSArray
                    
                    for unwrappedPlaceTimePairs in placesTimePairs {
                        var placeConnection = PlaceConnection()
                        placeConnections += [placeConnection]
                        
                        var placeTimePairs = unwrappedPlaceTimePairs as! NSDictionary
                        placeConnection.placeId =  placeTimePairs["placeId"] as! String
                        placeConnection.placeName = placeTimePairs["placeName"] as! String
                        
                        for unwrappedPeopleTimePairs in (placeTimePairs["peopleTimePairs"] as! NSArray) {
                            let peopleTimePair = unwrappedPeopleTimePairs as! NSDictionary
                            let connection = Connection()
                            placeConnection.peopleTimePairs += [connection];
                            connection.userId = peopleTimePair["userId"] as! String
                            connection.realUserName = peopleTimePair["realName"] as! String
                            
                            let placeTime: Connection.PlaceTime = Connection.PlaceTime()
                            placeTime.placeId = placeTimePairs["placeId"] as! String
                            placeTime.placeName = placeTimePairs["placeName"] as! String
                            connection.placesTimePairs += [placeTime]
                        
                            var totalTimeInSec:Double = 0
                            var lastSeenTime: Double = 0
                            for unwrappedTimePair in (peopleTimePair["timePairs"] as! NSArray) {
                                let startEndTime = unwrappedTimePair as! NSDictionary

                                let startTime = startEndTime.objectForKey("startTime") as! NSDate
                                let endTime = startEndTime.objectForKey("endTime") as! NSDate
                                let timeIntervalInSec = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
                                totalTimeInSec += timeIntervalInSec
                                placeTime.timePairs.append((startTime: startTime.timeIntervalSince1970, endTime: endTime.timeIntervalSince1970))
                                if endTime.timeIntervalSince1970 > lastSeenTime {
                                    lastSeenTime = endTime.timeIntervalSince1970
                                }
                            }
                            placeTime.totalTime = Int(totalTimeInSec)
                            placeTime.lastSeenTime = lastSeenTime
                            connection.computeLastPlaceSeen()
                            connection.computeTotalTimeInSec()
                        }
                        
                    }
                    
                    completion(placeConnections: placeConnections)
                }
                else {
                    //error occurred
                    print("Error retrieving overlapping places for user with id \(userID)")
                }
        })
    }
    
    ///
    /// Make call to Parse to add a new time pair for location
    ///
    class func addNewTimePair(userID: String, placeID: String, startTime: String, endTime: String) {
        PFCloud.callFunctionInBackground("addNewTimePair", withParameters: ["userId": userID, "placeId": placeID, "startT": startTime, "endT": endTime,], block:
            {
                (results: AnyObject?, error: NSError?) -> Void in
                if (error == nil) {
                    print("Successfully added new time pair to server")
                }
                else {
                    //error occurred
                    print("Error adding new time pair for place w/ ID \(placeID)")
                }
            })
        
    }
    
    
    ///
    /// Make call to Parse to return user object for given userID
    ///
    class func getUserByID(userId: String, completion: (user: User?) -> Void) {
        let query = PFUser.query()!
        query.getObjectInBackgroundWithId(userId) {
            (unwrappedUser: PFObject?, error: NSError?) -> Void in
            if error == nil && unwrappedUser != nil {
                let qUser = unwrappedUser!
                let user = User()
                user.objectId = qUser.objectId!
                user.gender = qUser.objectForKey("gender") as! String
                user.bio = qUser.objectForKey("bio") as! String
                user.realName = qUser.objectForKey("realName") as! String
                user.userName = qUser.objectForKey("username") as! String
                user.email = qUser.objectForKey("email") as! String
                completion(user: user)
            } else {
                print(error)
                completion(user: nil)
            }
        }
    }
    
}

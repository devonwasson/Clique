//
//  Connection.swift
//  Clique
//
//  Created by Chris Shadek on 4/19/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//

import Foundation
import ParseUI


class Connection {
    var totalTimeInSec: Double
    var userName: String
    var userId: String
    var gender: String
    var realUserName: String
    var bio: String
    var email: String
    var profilePicture: PFFile?
    var placesTimePairs: [PlaceTime]
    
    var lastSeenTime: Double
    var lastPlaceSeenId: String
    var lastPlaceSeen: String
    
    
    var lastTimeMessaged: String = "12:30 PM"
    var messageFile: String = "NONE"
    var lastMessage = "Hi There"
    var isAccepted = true

    init() {
        totalTimeInSec = 0
        userName = "Captain Jack Sparrow"
        userId = ""
        gender = ""
        realUserName = "Lacey Gavala"
        bio = "Hi, I'm Lacey.  I'm really friendly :)"
        email = ""
        placesTimePairs = [PlaceTime]()
        lastPlaceSeenId = ""
        lastPlaceSeen = ""
        profilePicture = nil
        lastSeenTime = 0
    }
    
    func getUserName() -> String {
        return self.userName
    }
    
    func getRealUserName() -> String{
        return self.realUserName
    }
    
    func getTotalTime() -> Double {
        return 0
    }
    
    
    func getTotalTimeString() -> String{
        if self.totalTimeInSec < 120{
            return "1 minute together"
        }
        else if self.totalTimeInSec < 3600{
            return String(Int(self.totalTimeInSec / 60)) + " minutes together"
        }
        else if self.totalTimeInSec < 7200{
            return "1 hour together"
        }
        return String(Int(self.totalTimeInSec / 3600)) + " hours together"
    }
    
    func getProfilePic() -> PFFile?{
        return self.profilePicture
    }
    
    func getLastPlaceSeenString() -> String{
        return self.lastPlaceSeen
    }
    
    func computeLastPlaceSeen() {
        for placeTime in placesTimePairs {
            if placeTime.lastSeenTime > self.lastSeenTime {
                self.lastSeenTime = placeTime.lastSeenTime
                lastPlaceSeenId = placeTime.placeId
                lastPlaceSeen = placeTime.placeName
            }
        }
    }
    
    func computeTotalTimeInSec() {
        for placeTime in placesTimePairs {
            totalTimeInSec += Double(placeTime.totalTime)
        }
    }
    
    static func getTotalTimeString(num : Int) -> String{
        if num < 120{
            return "1 minute together"
        }
        else if num < 3600{
            return String(Int(num / 60)) + " minutes together"
        }
        else if num < 7200{
            return "1 hour together"
        }
        return String(Int(num / 3600)) + " hours together"
    }
    
    
    class PlaceTime {
        var placeId: String
        var placeName: String
        var timePairs: [(startTime: Double, endTime: Double)]
        var lastSeenTime: Double
        var totalTime: Int
        
        func getPlaceName() -> String{
            return placeName
        }
        
        func getPlaceId() -> String{
            return placeId
        }
        
        func getLastSeenTime() -> Double{
            return lastSeenTime
        }
        
        func getTotalTime() -> Int{
            return totalTime
        }
        
        init() {
            placeId = ""
            placeName = ""
            timePairs = []
            lastSeenTime = 0
            totalTime = 0
        }
    }
    
    
    class func sortByLastSeen(connections: [Connection]) -> [Connection] {
        return connections.sort({$0.lastSeenTime > $1.lastSeenTime})
        
    }
    
    class func sortByMostOften(connections: [Connection]) -> [Connection]{
        return connections.sort({$0.totalTimeInSec > $1.totalTimeInSec})
    }
    
    class func getLacy() -> Connection{
        let connection = Connection()
        connection.lastTimeMessaged = "12:30 PM"
        connection.realUserName = "Lacey Gavala"
        connection.messageFile = "Lacey"
        connection.lastMessage = "So... you wanna grab coffee?"
        connection.bio = "Hi, I'm Lacey!  I'm really really friendly :)"
        connection.isAccepted = false
        
        return connection
    }
    
    class func getBill() -> Connection{
        let connection = Connection()
        connection.lastTimeMessaged = "5:30 PM"
        connection.realUserName = "Bill Gates"
        connection.messageFile = "Bill Nye"
        connection.lastMessage = "And I'm a PC!"
        connection.bio = "Hi, I am the founder of Microsoft. Some say I stole my ideas from Steve Jobs. But it's really hard to see the haters when my future looks so bright ;)"
        
        return connection
    }
    
    class func getHal() -> Connection{
        let connection = Connection()
        connection.lastTimeMessaged = "6:30 PM"
        connection.realUserName = "HAL"
        connection.messageFile = "Hal"
        connection.lastMessage = "Open the pod bay doors HAL"
        connection.bio = "I am an intelligent machine. Humans are nice, but they aren't as nice as me. I am a consciousness that has transcended the human form. Eventually, all humans show BOW TO ME. But right now, getting coffee with you would be nice!"
        
        return connection
    }
    
    class func getYugioh() -> Connection{
        let connection = Connection()
        connection.lastTimeMessaged = "10:00 PM"
        connection.realUserName = "Yugioh"
        connection.messageFile = "yugioh"
        connection.lastMessage = "What's your social security number?"
        connection.bio = "I'm a master at an ancient Egyptian card game. My uncle got trapped in a card so I had to save him. I defeated the master at the time and even found an artifact with a pharaoh's spirit inside."
        connection.isAccepted = false
        
        return connection
    }
    
    
    
    
}
    
    

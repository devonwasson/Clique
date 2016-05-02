//
//  Util.swift
//  Clique
//
//  Created by Li Li on 4/21/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//

import Foundation

var currentUserId = "chris"
var currentUserName = "evanPeck@bucknell.edu"
var currentUserRealName = "Evan Peck"
var currentUserEmail = "testUser@test.com"
var currentUserGender = "F"
var currentUserbio = "Hi! My name is Evan Peck, and I'm a professor at Bucknell University.  I research in the field of Human Computer Interaction and have interests in Data Visualization.  I love star gazing and long walks on the beach.  Feel free to message me, I don't bite! :)"
var mySpecialNotificationKey = "messageKey"

var messageRequests = [Connection.getLacy(), Connection.getYugioh()]
var messageConnections = [Connection.getBill(), Connection.getHal()]

protocol PubNubMessageDelegate: class {
    func sendMessage(message: String)
    func sendMessageWithConnection(message: String, connection: Connection)
}

var GlobalMainQueue: dispatch_queue_t {
    return dispatch_get_main_queue()
}

var GlobalUserInteractiveQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
}

var GlobalUserInitiatedQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
}

var GlobalUtilityQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.rawValue), 0)
}

var GlobalBackgroundQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)
}

public struct Alert{


    static func presentRequestAlert(view: ConversationContainerViewController) -> UIAlertController{
    
        let title = "This user has requested to talk to you"
        let message = "Would you like to start messaging?"
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelButton = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel) { (cancelSelected) -> Void in
            
            messageRequests.removeAtIndex(view.index)
            view.navigationController?.popViewControllerAnimated(true)
            
        }
        
        let continueButton = UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default) { (loginSelected) -> Void in
            view.connection.isAccepted = true
            
            messageConnections.insert(view.connection, atIndex: 0)
            messageRequests.removeAtIndex(view.index)

        }
        alert.addAction(cancelButton)
        alert.addAction(continueButton)
        return alert
    }

}


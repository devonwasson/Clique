//
//  Util.swift
//  Clique
//
//  Created by Li Li on 4/21/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//

import Foundation

var currentUserId = "testId"
var currentUserName = "testUserName"
var currentUserRealName = "testUserRealName"
var currentUserEmail = "testUser@test.com"
var currentUserGender = "F"
var currentUserbio = "test bio"
var mySpecialNotificationKey = "messageKey"

protocol PubNubMessageDelegate: class {
    func sendMessage(message: String)
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
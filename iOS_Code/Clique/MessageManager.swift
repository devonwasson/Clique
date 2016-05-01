//
//  MessageManager.swift
//  Clique
//
//  Created by Li Li on 4/25/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//

protocol MessageDelegate: class {
    func receivedNewMessages(messages: [Message])
}


class MessageManager{
    var delegate: MessageDelegate?
    let appDelegate = UIApplication.sharedApplication().delegate as! PubNubMessageDelegate
    
    
    init() {
        self.delegate = nil
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .actOnSpecialNotification, name: mySpecialNotificationKey, object: nil)
    }
    
    func setDelegate(delegate: MessageDelegate) {
        self.delegate = delegate
    }
    
    
    @objc func actOnSpecialNotification(notification:NSNotification) {
        if (delegate != nil) {
            let messages = Message.getAllMessagesFromCoreData()
            delegate!.receivedNewMessages(messages)
        }
    }
    
    func sendMessage(message: String) {
        appDelegate.sendMessage(message)
    }
    
    
    
}

// MARK: - Selector

/*
 Inspired by: https://medium.com/swift-programming/swift-selector-syntax-sugar-81c8a8b10df3#.4wgcad6ur
 */
private extension Selector{
    
    static let actOnSpecialNotification =
        #selector(MessageManager.actOnSpecialNotification(_:))

}
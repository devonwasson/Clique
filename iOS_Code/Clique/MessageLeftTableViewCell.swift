//
//  MessageLeftTableViewCell.swift
//  Clique
//
//  Created by Chris Shadek on 4/25/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//


class MessageLeftTableViewCell: UITableViewCell {

    
    @IBOutlet weak var messageText: UITextView!
    
    
    override func awakeFromNib() {
        self.messageText.layer.cornerRadius = 10
        self.messageText.layer.masksToBounds = true
        self.messageText.scrollEnabled = false
        messageText.sizeToFit()
        messageText.layoutIfNeeded()
        let height = messageText.sizeThatFits(CGSizeMake(messageText.frame.size.width, CGFloat.max)).height
        messageText.contentSize.height = height
    }
}

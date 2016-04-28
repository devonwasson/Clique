//
//  MessageRightTableViewCell.swift
//  Clique
//
//  Created by Chris Shadek on 4/25/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//

import UIKit

class MessageRightTableViewCell: UITableViewCell {

    @IBOutlet weak var messageText: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.messageText.layer.cornerRadius = 10
        self.messageText.layer.masksToBounds = true
        self.messageText.scrollEnabled = false
        messageText.sizeToFit()
        messageText.layoutIfNeeded()
        let height = messageText.sizeThatFits(CGSizeMake(messageText.frame.size.width, CGFloat.max)).height
        messageText.contentSize.height = height
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

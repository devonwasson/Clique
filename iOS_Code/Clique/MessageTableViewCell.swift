//
//  MessageTableViewCell.swift
//  Clique
//
//  Created by Chris Shadek on 4/25/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//


class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var timeStampLabel: UILabel!
    
    
    var connection = Connection()
    
    func updateCell(){
        //self.nameLabel.text = connection.getRealUserName()
        
    }
    
    override func awakeFromNib() {
        
        self.profileImage.layer.cornerRadius = 10
        self.profileImage.layer.masksToBounds = true
        
        
    }


}

//
//  MyProfileTopCell.swift
//  Clique
//
//  Created by Chris Shadek on 4/25/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//


class MyProfileTopCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var connection = Connection()
    
    override func awakeFromNib() {
        
        self.profilePic.layer.cornerRadius = 10
        self.profilePic.layer.masksToBounds = true
        
        
    }
    
    func updateCell(){
        self.nameLabel.text = connection.getRealUserName()
    }
}

//
//  OtherProfileTopCell.swift
//  Clique
//
//  Created by Chris Shadek on 4/21/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//

import ParseUI
class OtherProfileTopCell: UITableViewCell {


    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var bioTextView: UITextView!
    
    var connection = Connection()
    override func awakeFromNib() {
        
        self.profilePic.layer.cornerRadius = 10
        self.profilePic.layer.masksToBounds = true
        
        
    }
    
    func updateCell(){
        self.nameLabel.text = connection.getRealUserName()
        self.bioTextView.text = connection.bio
    }
}

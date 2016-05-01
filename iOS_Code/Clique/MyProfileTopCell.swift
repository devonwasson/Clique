//
//  MyProfileTopCell.swift
//  Clique
//
//  Created by Chris Shadek on 4/25/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//

import ParseUI

class MyProfileTopCell: UITableViewCell {

    @IBOutlet weak var profilePic: PFImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var bioTextView: UITextView!
    
    
    override func awakeFromNib() {
        
        self.profilePic.layer.cornerRadius = 10
        self.profilePic.layer.masksToBounds = true
        
        
    }
    
    func updateCell(){
        self.nameLabel.text = currentUserRealName
        self.bioTextView.text = currentUserbio
        
//        if profilePic != nil{
//            self.profilePic.file = connection.profilePicture
//            self.profilePic.loadInBackground()
//            
//        }
    }
}

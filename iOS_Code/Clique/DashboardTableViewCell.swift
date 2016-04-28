//
//  DashboardTableViewCell.swift
//  Clique
//
//  Created by Chris Shadek on 4/19/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//


class DashboardTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    @IBOutlet weak var placeLabel: UILabel!
    var connection = Connection()

    func updateCell(){
        self.nameLabel.text = connection.getRealUserName()
        self.totalTimeLabel.text = connection.getTotalTimeString()
        self.placeLabel.text = "Recently seen at " + connection.getLastPlaceSeenString()
        
        
    }
    
    override func awakeFromNib() {
        
        self.profileImage.layer.cornerRadius = 10
        self.profileImage.layer.masksToBounds = true
        
        
    }
    
}

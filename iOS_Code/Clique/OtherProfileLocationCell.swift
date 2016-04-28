//
//  OtherProfileLocationCell.swift
//  Clique
//
//  Created by Chris Shadek on 4/22/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//


class OtherProfileLocationCell: UITableViewCell {

    @IBOutlet weak var locationNameLabel: UILabel!
    
    @IBOutlet weak var barGraph: UIView!
    var location = Connection.PlaceTime()
    
    func updateCell(){
        self.locationNameLabel.text = location.getPlaceName() + " – " + Connection.getTotalTimeString(location.getTotalTime())
    }
}

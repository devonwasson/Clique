//
//  OtherProfileBottomCell.swift
//  Clique
//
//  Created by Chris Shadek on 4/25/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//


class OtherProfileBottomCell: UITableViewCell {

    
    @IBOutlet weak var blockButton: UIButton!
    var connection = Connection()
    func updateCell(){
        blockButton.setTitle("Block " + connection.getRealUserName() + "?", forState: .Normal)
    }
}

//
//  DashboardContainerViewController.swift
//  Clique
//
//  Created by Chris Shadek on 4/24/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//


class DashboardContainerViewController: UIViewController {

    @IBOutlet weak var segmentedFilter: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.segmentedFilter.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.blueColor()
        
        
    }
}

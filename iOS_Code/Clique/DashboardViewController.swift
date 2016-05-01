//
//  DashboardViewController.swift
//  Clique
//
//  Created by Kyle Raudensky on 4/4/16.
//  Copyright © 2016 BuckMe. All rights reserved.
//

import UIKit
import Parse

class DashboardViewController: UITableViewController {
    
    
    @IBOutlet weak var segmentedFilter: UISegmentedControl!
    var connections = [Connection]()
    
    @IBAction func filterChanged(sender: AnyObject) {
        
        if segmentedFilter.selectedSegmentIndex == 0{
            self.connections = Connection.sortByLastSeen(connections)
        }
        else{
            self.connections = Connection.sortByMostOften(connections)
        }
        
        self.tableView.reloadData()
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.segmentedFilter.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.backgroundColor = UIColor.blueColor()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        self.reloadData()

    }
    
    
    /**
     Called to refresh the tableview's data
     */
    func refresh(sender:AnyObject){
        
        self.reloadData()
        refreshControl?.endRefreshing()
        
    }
    
    func segmentedFilterValueChanged(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            //sort connections by recently seen
            print("HERE")
        }
        else if segment.selectedSegmentIndex == 1 {
            //sort connections by most often seen
        }
        else if segment.selectedSegmentIndex == 2 {
            //change view to list locations
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning complete implementation, return the number of sections

        return 1
    }
    
    /*
     Returns the number of rows in a section in the table view
     */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return self.connections.count
    }
    
    /**
     Called to reload the tableview's data
     */
    func reloadData(){
        // Call Parse Fetcher Function to get array of Connections
        
        ParseFetcher.getOverlappingUsersWithInformation("vJWd1CVvex", completion:
            {
                (connections: [Connection]) in
                self.connections = connections
                self.filterChanged(self.segmentedFilter)
        })
    }
    
    /**
     Called when the event list is updated from the server
     */
    func eventListUpdate(notification:NSNotification){
        self.tableView.reloadData()
    }
    
    
    /*
     Configures each cell of the table
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> DashboardTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dashboardCell", forIndexPath: indexPath) as! DashboardTableViewCell
        
        // Configure the cell...
        
        let cellNum = indexPath.row
        let cellConnection = connections[cellNum]
        cell.connection = cellConnection
        cell.updateCell()
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextScene = segue.destinationViewController as! OtherProfilesTableViewController
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! DashboardTableViewCell
            nextScene.connection = cell.connection
        }
    }
    
    /*
     Sets the automatic height of the cells
     */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    /*
     Sets the estimated automatic height of the cells
     */
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
//    /*
//     Sets the automatic height of the cells
//     */
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//    
//    
//    /*
//     Sets the estimated automatic height of the cells
//     */
//    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
}


// MARK: - Selector

/*
 Inspired by: https://medium.com/swift-programming/swift-selector-syntax-sugar-81c8a8b10df3#.4wgcad6ur
 */
private extension Selector{
    
    static let eventListUpdate =
        #selector(DashboardViewController.eventListUpdate(_:))
}



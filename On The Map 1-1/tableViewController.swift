//
//  tableViewController.swift
//  On The Map 1-1
//
//  Created by Cesar Ramirez on 8/9/15.
//  Copyright (c) 2015 Cesar Ramirez. All rights reserved.
//

import Foundation
import UIKit

class studentsTableViewController: UITableViewController{

    override func viewDidLoad() {
      super.viewDidLoad()
        
        self.parentViewController!.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refresh")
        
        self.parentViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: "Logout")
        
        
        self.tableView.reloadData()

        }
   
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OTMNetworking.SharedInstance.students.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "FavoriteTableViewCell"
        let student = OTMNetworking.SharedInstance.students[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! UITableViewCell
        cell.textLabel!.text = student.firstName + " " + student.lastName
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = OTMNetworking.SharedInstance.students[indexPath.row]
        let url = NSURL(string: student.mediaURL!)
        UIApplication.sharedApplication().openURL(url!)
    }

    

    
    
    func refresh(){
        self.getStudentLocations()
    }
    
    func Logout(){
        publicClass().logout()
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        self.presentViewController(controller, animated: true, completion: nil)

        
    }


    func getStudentLocations(){
        OTMNetworking().getStudentLoca{students, error in

            if error == nil {

                let students = students
                OTMNetworking.SharedInstance.students = students!

                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }else{

                var alert = UIAlertView(title: nil, message: error, delegate: self, cancelButtonTitle: "Please try Again")
                alert.show()
            }
        }
    }


}

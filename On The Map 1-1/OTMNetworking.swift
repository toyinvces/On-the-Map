//
//  OTMNetworking.swift
//  On The Map 1-1
//
//  Created by Cesar Ramirez on 9/5/15.
//  Copyright (c) 2015 Cesar Ramirez. All rights reserved.
//

import Foundation
import UIKit

class OTMNetworking{

    struct SharedInstance {
        static var students: [Student] = [Student]()
    }
   
    var firstName: AnyObject!
    var lastName: AnyObject!
    var URLText: String!
    var latitude: Double!
    var longitude: Double!
    var userKey: AnyObject!
    var placeName: String!

func getStudentLoca(completionHandler: (result: [Student]?, error: String?) -> Void){
    let methodParameters = [
        "limit": 100
    ]
    
    var result: NSString
    var finalResult: String
    
    let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?order=-updatedAt")!)
    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")

    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
        if error != nil { // Handle error...
            
            completionHandler(result: SharedInstance.students, error: "Connection error")
            return
        }
        
        var parsingError: NSError? = nil
        let parsedResult: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments, error: &parsingError)

        let newResults: AnyObject? = (parsedResult["results"])
        
        if newResults == nil {
                completionHandler(result: nil, error: "Error receving Data")
        } else{
                let results = parsedResult!.valueForKey("results") as? [[String : AnyObject]]
                SharedInstance.students = Student.studentsFromResults(results!)
                completionHandler(result: SharedInstance.students, error: nil)
        }
       
    }
    task.resume()
    
}

    func postData (){
        
        latitude = User.latitude
        longitude = User.longitude
        firstName = User.firstName
        lastName = User.lastName
        userKey = User.Key
        URLText = User.URL
        placeName = User.placeName
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"uniqueKey\": \"\(self.userKey)\", \"firstName\": \"\(self.firstName)\", \"lastName\": \"\(self.lastName)\",\"mapString\":  \"\(self.placeName)\",  \"mediaURL\":  \"\(self.URLText)\",\"latitude\": \(self.latitude), \"longitude\": \(self.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                
                var alert = UIAlertView(title: nil, message: "Error posting", delegate: self, cancelButtonTitle: "Please try Again")
                alert.show()
                
                return
            }
            
        }
        task.resume()
        
    }

}
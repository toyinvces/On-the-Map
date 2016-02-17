//
//  Public.swift
//  On The Map 1-1
//
//  Created by Cesar Ramirez on 8/31/15.
//  Copyright (c) 2015 Cesar Ramirez. All rights reserved.
//

import Foundation
import UIKit

class publicClass {
    
    var allData: AnyObject!
    var errorString: String!
    var user: String!
    var pass: String!
    var error: AnyObject!
    var sucess: Bool!
    var userKey: String!
    
    func loginAgain(userName: String!, password: String!, completionHandler: (success: Bool, errorString: AnyObject?, key: String!) -> Void){
        
        user = userName!
        pass = password!
        
        let urlString = "https://www.udacity.com/api/session"
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(self.user!)\", \"password\": \"\(self.pass!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)

        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                
                let key: AnyObject!
                println("loging error")
                completionHandler(success: false, errorString: "Couldn't connect, please check your connection" , key: "")
                return
  
            
            } else{
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            var parsingError: NSError? = nil
            let parsedResult: AnyObject! = NSJSONSerialization.JSONObjectWithData(newData, options:NSJSONReadingOptions.AllowFragments, error: &parsingError)

                
            let error = parsedResult["error"]
                
            let status = parsedResult["status"] as? Int
            
                if status == nil {
                    let account = parsedResult["account"] as! NSDictionary
                    if let key: AnyObject = account["key"]{
                        self.userKey = key as! String
                    }
                    
                    completionHandler(success: true, errorString: "success", key: self.userKey)
           
                } else{
                    completionHandler(success: false, errorString: error, key: self.userKey)
                }
                
                return
            }
            
        }
        task.resume()
        
    }
    
    func getData(){
        
        let key: AnyObject! = User.Key
        
        let urlString = "https://www.udacity.com/api/users/" + "\(key)"
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            var parsingError: NSError? = nil
            let parsedResult: AnyObject! = NSJSONSerialization.JSONObjectWithData(newData, options:NSJSONReadingOptions.AllowFragments, error: &parsingError)
                        
            if let user = (parsedResult["user"]) as? NSDictionary {
  
                let lastName: (AnyObject?) = (user["last_name"])
                let firstName: (AnyObject?) = (user["first_name"])
                
                User.lastName = lastName
                User.firstName = firstName
                }

                
            
        }
        task.resume()
    }

    
    func logout(){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                var alert = UIAlertView(title: nil, message: "Connection Error", delegate: self, cancelButtonTitle: "Please try Again")
                alert.show()
                
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            println(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }

    
}


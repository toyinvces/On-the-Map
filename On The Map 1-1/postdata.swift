//
//  postdata.swift
//  On The Map 1-1
//
//  Created by Cesar Ramirez on 8/17/15.
//  Copyright (c) 2015 Cesar Ramirez. All rights reserved.
//

import Foundation


struct PostStudentData {
    
    var key: String?
//    var latitude: Double? = nil
//    var longitude: Double? = nil
 //   var url: String
    
    init(dictionary: [String : AnyObject]) {
        key = dictionary["key"] as? String
//        latitude = dictionary["latitude"] as? Double
//        longitude = dictionary["longitude"] as? Double
//        url = dictionary["url"] as! String
    }
    


    
    static func dataFromResults(data: [[String : AnyObject]]) -> [PostStudentData] {
        
        var postStudentData = [PostStudentData]()
        
        /* Iterate through array of dictionaries; each Movie is a dictionary */
        for datas in data {
            
            postStudentData.append(PostStudentData(dictionary: datas))
           
        }
        
        return postStudentData
    }
    
}
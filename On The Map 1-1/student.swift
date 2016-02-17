//
//  student.swift
//  On The Map 1-1
//
//  Created by Cesar Ramirez on 8/4/15.
//  Copyright (c) 2015 Cesar Ramirez. All rights reserved.
//

import UIKit

struct Student {

    var firstName = ""
    var lastName = ""
    var latitude: Double? = nil
    var longitude: Double? = nil
    var mediaURL: String?

    init(dictionary: [String : AnyObject]) {
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
        mediaURL = dictionary["mediaURL"] as? String
    }

    static func studentsFromResults(results: [[String : AnyObject]]) -> [Student] {

        var students = [Student]()
        for result in results {
            students.append(Student(dictionary: result))
        }

        return students
    }

}

struct User {
    
    static var firstName: AnyObject!
    static var lastName: AnyObject!
    static var Key: AnyObject!
    static var URL: String!
    static var latitude: Double!
    static var longitude: Double!
    static var placeName: String!

}




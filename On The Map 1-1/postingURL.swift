//
//  postingURL.swift
//  On The Map 1-1
//
//  Created by Cesar Ramirez on 8/16/15.
//  Copyright (c) 2015 Cesar Ramirez. All rights reserved.
//

import Foundation
import MapKit
import UIKit


class postURL: UIViewController{

       var firstName: AnyObject!
        var lastName: AnyObject!
        var text: String!
        var key: String!
    
    var appDelegate = AppDelegate()
    
        @IBOutlet weak var URLText: UITextField!
        @IBOutlet weak var submit: UIButton!
 
        var annotation:MKAnnotation!
        var pointAnnotation: MKPointAnnotation!
        var pinAnnotationView:MKPinAnnotationView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        appending()
    }

    @IBAction func submitData(sender: AnyObject) {
        
        User.URL = URLText.text
        OTMNetworking().postData()
        
        presentMain()
        
    }

    
    func appending() {
        
        var annotations = [MKPointAnnotation]()
        
        let lat = User.latitude
        let long = User.longitude
            
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        var annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotations.append(annotation)
        
        self.mapView.addAnnotations(annotations)
    
    }

    func presentMain(){
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("navController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })

    }

}
    
    


        
        

    
    
    

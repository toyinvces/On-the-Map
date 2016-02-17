//
//  mapView.swift
//  On The Map 1-1
//
//  Created by Cesar Ramirez on 7/25/15.
//  Copyright (c) 2015 Cesar Ramirez. All rights reserved.
//


import UIKit
import MapKit

class mapViewController: UIViewController, MKMapViewDelegate {
 
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        mapView.delegate = self
        
        self.parentViewController!.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refresh")
        
        self.parentViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: "Logout")
                
        self.getStudentLocations()
    }
    
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        if control == view.rightCalloutAccessoryView {
            
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: view.annotation.subtitle!)!)
            
        }
        
    }
    
    func appending() {
        
        var annotations = [MKPointAnnotation]()
 
        for Dictionary in  OTMNetworking.SharedInstance.students{
            
            let lat = CLLocationDegrees(Dictionary.latitude!)
            let long = CLLocationDegrees(Dictionary.longitude!)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
  
            let first = Dictionary.firstName
            let last = Dictionary.lastName
  
            
            var annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = Dictionary.mediaURL
            annotations.append(annotation)
            
            self.mapView.addAnnotations(annotations)
        }
        
    }

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    func getStudentLocations(){
        OTMNetworking().getStudentLoca{students, error in
            
        //    if students != nil {
            
            if error == nil{
            
                let students = students
                OTMNetworking.SharedInstance.students = students!
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.appending()
                }
                
            }else{                
                var alert = UIAlertView(title: nil, message: error, delegate: self, cancelButtonTitle: "Please try Again")
                alert.show()
                
                
              //  }
            }
        }
    }

    
    
    func refresh(){
        
        self.getStudentLocations()
    }
    
    func Logout(){
        publicClass().logout()
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        self.presentViewController(controller, animated: true, completion: nil)

    }
    
  }

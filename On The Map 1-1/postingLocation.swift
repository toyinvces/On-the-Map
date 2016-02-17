//
//  posting.swift
//  On The Map 1-1
//
//  Created by Cesar Ramirez on 8/14/15.
//  Copyright (c) 2015 Cesar Ramirez. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class postingARequest: UIViewController{
    
    var long: String!
    var lata: String!
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var searchBar: UITextField!
    
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation: MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    @IBAction func searchButton(sender: AnyObject) {
        
        
        self.searchBarSearchButtonClicked()
    }
    
    func searchBarSearchButtonClicked(){
        
        activityIndicator.startAnimating()
        
        var long: Double!
        var lata: Double!
    
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text!
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                var alert = UIAlertView(title: nil, message: "Place not found", delegate: self, cancelButtonTitle: "Try again")
                alert.show()
                return
            }
        self.pointAnnotation = MKPointAnnotation()
        self.pointAnnotation.title = self.searchBar.text!
        self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse.boundingRegion.center.latitude, longitude:     localSearchResponse.boundingRegion.center.longitude)

        let long = self.pointAnnotation.coordinate.longitude
        let lata = self.pointAnnotation.coordinate.latitude
            
            User.latitude = lata
            User.longitude = long
            User.placeName = self.searchBar.text
            
            self.activityIndicator.stopAnimating()
            
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("postURL") as! postURL
        self.presentViewController(controller, animated: true, completion: nil)

        }
    }
    
    var backgroundGradient: CAGradientLayer? = nil
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    
    override func viewWillAppear(animated: Bool) {
        self.subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification:NSNotification){
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        if searchBar.editing {
            return keyboardSize.CGRectValue().height - 100
        }
        else {
            return 0
        }
        
    }
    
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:" , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
    }


}




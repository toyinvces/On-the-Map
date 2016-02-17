//
//  ViewController.swift
//  On The Map 1-1
//
//  Created by Cesar Ramirez on 7/20/15.
//  Copyright (c) 2015 Cesar Ramirez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var singUp: UIButton!
    
    var userName: String!
    var password: String!
    
    var sucess: Bool!
    var errorString: String!
    
    var keyID: String!

    
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
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
            if passwordTextField.editing {
                return keyboardSize.CGRectValue().height - 50
                }
            else if usernameTextField.editing{
                return keyboardSize.CGRectValue().height - 50
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        session = NSURLSession.sharedSession()
        
    }
  
    
    
    @IBAction func loginButton(sender: AnyObject) {
        
        if usernameTextField.text.isEmpty == true || passwordTextField.text.isEmpty {
            
            var alert = UIAlertView(title: nil, message: "Empty E-mail or password", delegate: self, cancelButtonTitle: "Try Again")
            alert.show()
            return
            
            
        } else{
            self.login()
        
        }

    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("navController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
 
    @IBAction func signUp(sender: AnyObject) {
        
        var url : NSURL
        url = (NSURL(string: "https://www.google.com/url?q=https%3A%2F%2Fwww.udacity.com%2Faccount%2Fauth%23!%2Fsignin&sa=D&sntz=1&usg=AFQjCNERmggdSkRb9MFkqAW_5FgChiCxAQ")!)
        UIApplication.sharedApplication().openURL(url)
        
    }
    
    func login(){
                
        userName = usernameTextField.text
        password = passwordTextField.text
        
            publicClass().loginAgain(userName!, password: password!) {(success, errorString, key) in
                if success {
                    User.Key = key
                    publicClass().getData()
                    self.completeLogin()
                    
                } else {
                    var error: String! = errorString as! String!
                    var alert = UIAlertView(title: nil, message: error, delegate: self, cancelButtonTitle: "Try again")
                    alert.show()
                    return
                }
            }
        
        return
        
    }


}


//
//  ViewController.swift
//  LoginWithGmail
//
//  Created by Rakesh Koplod on 29/06/15.
//  Copyright (c) 2015 Rakesh Koplod. All rights reserved.
//

import UIKit

class ViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {

    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var userToken: UILabel!
    @IBOutlet weak var emailID: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userID: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            // Signed in
            self.signInButton.hidden = true
            self.signOutButton.hidden = false
           GIDSignIn.sharedInstance().signInSilently()
        } else {
           self.signInButton.hidden = false
            self.signOutButton.hidden = true
        }
        
    }
    
    @IBAction func logOutClicked(sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        self.signInButton.hidden = false
        self.signOutButton.hidden = true
        self.userID.text = "Logged out"
        self.userName.text = "Logged out"
        self.emailID.text = "Logged out"
        self.userToken.text = "Logged out"
    }
    
    func application(application: UIApplication,
        openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
            return GIDSignIn.sharedInstance().handleURL(url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
        withError error: NSError!) {
            if (error == nil) {

                let userId = user.userID
                let idToken = user.authentication.idToken
                let name = user.profile.name
                let email = user.profile.email
                
                self.signInButton.hidden = true
                self.signOutButton.hidden = false
                
                self.userID.text = user.userID
                self.userName.text = user.profile.name
                self.emailID.text = user.profile.email
                self.userToken.text = user.authentication.idToken
                
            } else {
                println("\(error.localizedDescription)")
            }
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


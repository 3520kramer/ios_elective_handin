//
//  ViewController.swift
//  LoginApp
//
//  Created by Oliver Kramer on 10/04/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit
import FacebookLogin

class ViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    var firebaseAuthManager: FirebaseAuthManager?
    var facebookAuthManager: FacebookAuthManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        firebaseAuthManager = FirebaseAuthManager(parentVC: self)
        facebookAuthManager = FacebookAuthManager(parentVC: self)
        
        // Makes the password-dots instead of text entry
        passwordTextfield.isSecureTextEntry = true

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        firebaseAuthManager?.closeListener()
    }
    
    @IBAction func signInToFirebaseWithFacebookPressed(_ sender: Any) {
        facebookAuthManager?.signInFacebook()
    }
    
    
    
    @IBAction func signUp(_ sender: Any) {
        if verify().isOK{
            // uses the content of the tuple (.email and .password) that the verify function is returning to sign up
            firebaseAuthManager?.signUp(email: verify().email, password: verify().password)
        }else{
            print("email and password must each be 6 characters or more!")
        }
            
    }
    
    @IBAction func signIn(_ sender: Any) {
        if verify().isOK{
            // uses the content of the tuple (.email and .password) that the verify function is returning to sign in
            firebaseAuthManager?.signIn(email: verify().email, password: verify().password)
        }else{
            print("email and password must each be 6 characters or more!")
        }
    }

    @IBAction func signOut(_ sender: Any) {
        firebaseAuthManager?.signOut()
    }
    
    // function to verify user input
    // uses the textfields to determine whether the input is good enough
    func verify() -> (email: String, password: String, isOK: Bool){
        if let email = emailTextfield.text, let password = passwordTextfield.text{
            if email.count > 5 && password.count > 5{
                return (email, password, true) // tuple
            }
        }
        return ("","",false)
    }
    
    // Sets up a facebook login button using facebooks own setup
    func setUpFacebookButton(){
        let loginButton = FBLoginButton(permissions: [ .publicProfile ])
        loginButton.center = view.center

        view.addSubview(loginButton)
        
        /*
        // Tried moving the button by setting contraints
        let myConstraint = NSLayoutConstraint(item: loginButton, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: -20)
        
        self.view.addConstraint(myConstraint)
        loginButton.addConstraint(myConstraint)*/
    }
}


//
//  AuthentificationManager.swift
//  LoginApp
//
//  Created by Oliver Kramer on 12/04/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseAuthManager{
    
    var handle: AuthStateDidChangeListenerHandle
    var auth = Auth.auth()
    
    let parentVC: UIViewController
    
    init(parentVC: UIViewController){
        self.parentVC = parentVC // The view controller passed as an argument, sets the parent view controller of this class, so we can use it in other 
        
        handle = auth.addIDTokenDidChangeListener { (auth, user) in
            // do stuff...
            
            if let user = user {
                print("ID: \(user.uid)")
                print("Name: \(user.displayName)")
                print("Email: \(user.email)")
            }
        }
    }
    
    func closeListener(){
        self.auth.removeIDTokenDidChangeListener(handle)
    }
    
    func signUp(email: String, password: String){
        auth.createUser(withEmail: email, password: password)  { (authResult, error) in
            // perform segue
            if error == nil {
                print("signed up succesfully")
                print(authResult?.user.email)
                
                self.parentVC.performSegue(withIdentifier: "personalSegue", sender: nil)
            }else{
                print("Error: \(error.debugDescription)")
            }
        }
        
    }
    
    func signIn(email: String, password: String){
        auth.signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            guard let self = self else { return }
            
            if error == nil{
                print("SUCCES")
                self.parentVC.performSegue(withIdentifier: "personalSegue", sender: nil)
            }else{
                print("Failed")
            }
        }
    }
    
    func signInUsingFacebookCredentials(tokenString: String){
        let facebookCredential = FacebookAuthProvider.credential(withAccessToken: tokenString)
        
        auth.signIn(with: facebookCredential) { (authResult, error) in
            if error == nil{
                print("logged in to firebase using facebook credentials \(authResult?.description)")
                self.parentVC.performSegue(withIdentifier: "personalSegue", sender: nil)
            }else{
                print("failed to log in to firebase using facebook credentials \(error.debugDescription)")
            }
        }
    }
    
    func signOut(){
        do{
            try auth.signOut()
            print("Signed out succesfully")
            if auth.currentUser == nil{
                self.parentVC.navigationController?.popViewController(animated: true)
            }
        }catch let error{
            print("Failed to sign out: \(error.localizedDescription)")
        }
    }
    
}

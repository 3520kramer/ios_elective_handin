//
//  FacebookAuthManager.swift
//  LoginApp
//
//  Created by Oliver Kramer on 24/04/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin

class FacebookAuthManager{
    
    var parentVC: ViewController
    
    init(parentVC: ViewController){
        self.parentVC = parentVC
    }
    
    func signInFacebook(){
        print("Facebook login started")
        
        // the login manager is functionality we get from the FBSDKLoginKit
        let manager = LoginManager()
        
        manager.logIn(permissions: [.publicProfile, .email], viewController: parentVC){ (result) in
            print("loggin in to facebook \(result)")
            
            switch result{
                case .cancelled:
                    print("login cancelled")
                    
                case .failed(let error):
                    print("login failed \(error.localizedDescription)")

                case let .success(granted: _, declined: _, token: token):
                    // this case creates three sets, but we only need the token
                    // we create the fields by placing the let in front of .success
                    // would have looked like this normally:
                    //case .success(granted: let granted, declined: let declined, token: let token):
                    // we place the underscore to specify that we don't need it
                    
                    self.parentVC.authManager?.signInUsingFacebookCredentials(tokenString: token.tokenString)
                    
            }
        }
    }
}

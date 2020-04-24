//
//  ViewController2.swift
//  LoginApp
//
//  Created by Oliver Kramer on 13/04/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit

class ViewControllerPersonal: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var facebookNameLabel: UILabel!
    @IBOutlet weak var facebookProfilePicImage: UIImageView!
    
    
    var authManager: AuthorizationManager?
    var facebookGraphRequest: FacebookGraphRequest?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authManager = AuthorizationManager(parentVC: self)
        facebookGraphRequest = FacebookGraphRequest(parentVC: self)
                
        welcomeLabel.text = "Welcome user with email: \(authManager?.auth.currentUser?.email)"
        print("curr user: \(authManager?.auth.currentUser?.email)")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        authManager?.closeListener()
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        authManager?.signOut()
    }
    
    @IBAction func getDataFromFacebookPressed(_ sender: Any) {
        facebookGraphRequest?.makeGraphRequest()
    }
    
    
    // PERSONALIZE THE LABEL

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

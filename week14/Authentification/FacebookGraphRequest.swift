//
//  FacebookGraphRequest.swift
//  LoginApp
//
//  Created by Oliver Kramer on 24/04/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation
import FacebookCore

class FacebookGraphRequest{
    
    var parentVC: ViewControllerPersonal
    
    init(parentVC: ViewControllerPersonal) {
        self.parentVC = parentVC
    }
    
    // makes the request which handles getting facebook user data
    func makeGraphRequest(){
        if let tokenString = AccessToken.current?.tokenString{
            let graphRequest = GraphRequest(graphPath: "/me",
                                            parameters: ["fields": "id, name, email, picture.width(400)"],
                                            tokenString: tokenString,
                                            version: Settings.defaultGraphAPIVersion,
                                            httpMethod: .get)
            let connection = GraphRequestConnection()
            connection.add(graphRequest){(connection, result, error) in
                if error == nil, let result = result{
                    let dict = result as! [String:Any] // casts the result to a dictionary
                    let name = dict["name"] as! String
                    let email = dict["email"] as! String
                    
                    print("got data from facebook: Name: \(name) -- Email: \(email) ")
                    print(dict)
                    
                }else{
                    print("error making graph request: \(error.debugDescription)")
                }
            }
            connection.start()
        }
    }
}

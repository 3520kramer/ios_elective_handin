//
//  Note.swift
//  MyNotebookCloudPictures
//
//  Created by Oliver Kramer on 07/03/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation
import UIKit

class Note{
    var id:String?
    var dateTime:String?
    var title:String?
    var body:String?
    var image:String?
    var uiimage:UIImage?
    
    
    // constructor for creating new note from add-button
    // In this constructor we initialize a date object and changes it format
    init (id:String){
        self.id = id
        self.title = "New note"
        self.body = "Enter text here..."
        self.image = ""
        print("note data: \(Date.init())")
        
        // Creates a dateformatter and changes format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM-yyyy HH:mm:ss"
        
        // Creates a Date object to find the date and time
        let currDate = Date.init()
        
        // Sets the dateTime for this object to the date and time from currDate
        self.dateTime = dateFormatter.string(from: currDate)
        
        // FOR TESTING ONLY
        if let datePrint = self.dateTime{
            print("From add-button: \(datePrint)")
        }
    }
    
    // Constructor for creating notes from database
    init (id:String, dateTime:String, title:String, body:String, image:String){
        self.id = id
        self.title = title
        self.body = body
        self.image = image
        
        // Creates a dateformatter and changes format
        let dateFormatter = DateFormatter() ///
        dateFormatter.dateFormat = "dd/MM-yyyy HH:mm:ss"
        
        // creates a Date object if true
        if let currDate = dateFormatter.date(from: dateTime){
            
            //dateFormatter.date(from: currDate.description)
            
            // Sets the dateTime for the Note object to the date and time from currDate
            self.dateTime = dateFormatter.string(from: currDate)
        }
        
        // FOR TESTING ONLY
        if let datePrint = self.dateTime{
            print("From database: \(datePrint)")
        }
    }
    
    func hasImage() -> Bool {
        if uiimage != nil{
            return true
        }else{
            return false
        }
    }
}

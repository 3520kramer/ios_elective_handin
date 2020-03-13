//
//  File.swift
//  MyNotebookCloudPictures
//
//  Created by Oliver Kramer on 07/03/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation
import FirebaseFirestore

class CloudFirebase{
    
    private static let db = Firestore.firestore()
    private static let notesCollection = "notes"
    
    // listens for changes and updates if changes are made to db
    // uses a completionhandler to make sure that the for loop is finished iterating through snap.documents
    // The first parameter ([Note]) is used to declare what type we we wan't to pass through the function in the parameter of completion when we are finished with the for loop
    static func startListener(completion: @escaping ([Note]) -> ()){
        // array to hold the note objects
        var dbArray = [Note]()
        print("starting listener")
        db.collection(notesCollection).addSnapshotListener { (snap, error ) in
            print("yes")
            if error == nil{
                dbArray.removeAll()
                for note in snap!.documents {
                    let map = note.data()
                    
                    // if we can unwrap all the optionals then we create a new note object of the undwrapped data
                    if let dateTime = map["dateTime"] as? String,
                        let title = map["title"] as? String,
                        let text = map["body"] as? String,
                        let image = map["image"] as? String{
                        let newNote = Note(id: note.documentID, dateTime: dateTime, title: title, body: text, image: image)
                        dbArray.append(newNote)
                    //if we can't unwrap all of them, then there might be a problem with one of them, and the we create a dictionary to check which optional that is the problem
                    }else{
                        print("Error creating a new Note from Firebase:")
                        // Creating a dictionary to find which field is the problem
                        var newNoteDict:[String:String] = ["ID":note.documentID, "DateTime":"***Error fetching data***","Title":"***Error fetching data***","Body":"***Error fetching data***","Image":"***Error fetching data***"]
                        
                        if let dateTime = map["dateTime"] as? String{
                            newNoteDict.updateValue(dateTime, forKey: "DateTime")
                        }
                        if let title = map["title"] as? String{
                            newNoteDict.updateValue(title, forKey: "Title")
                        }
                        if let body = map["body"] as? String{
                            newNoteDict.updateValue(body, forKey: "Body")
                        }
                        if let image = map["image"] as? String{
                            newNoteDict.updateValue(image, forKey: "Image")
                        }
                        // Here we print the dictionary
                        for (key, value) in newNoteDict.enumerated(){
                            print(key, value)
                        }
                    }
                }
                // completion handler to make sure that the iteration over snap.documents is done before passing the array through the function, so it can be used in the TableViewController
                completion(dbArray)
            }else{
                print("Error: \(error.debugDescription)")
            }
        }
    }
    
    // Date and time function
    static func findDateTime() -> String{
        // Creates a dateformatter and changes format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss dd/MM-yyyy"
        
        // Creates a Date object to find the date and time
        let currDate = Date.init()
        
        // Returns string representation of date and time
        return dateFormatter.string(from: currDate)
    }
    
    static func insertNote(){
        let docRef = db.collection(notesCollection).document()
        
        var map = [String:String]()
        map["title"] = "New note"
        map["dateTime"] = findDateTime()
        map["body"] = ""
        
        docRef.setData(map)
    }
    
    static func delete(id:String){
        // if you pass something in document parameter you will get that, if you doesn't pass anything (or a wrong id) it will get an empty
        let docRef = db.collection(notesCollection).document(id)
        docRef.delete()
    }
    /*
    static func update(id:String, dateTime: String, title:String, text:String, image:String){
        let docRef = db.collection(notesCollection).document(id)
        
        var map = [String:String]()
        map["dateTime"] = dateTime
        map["title"] = title
        map["text"] = text
        
        docRef.setData(map)
    }
    */
    static func update(note: Note){
         if let id = note.id, let dateTime = note.dateTime, let title = note.title, let body = note.body, let image = note.image{
                let docRef = db.collection(notesCollection).document(id)
                
                var map = [String:String]()
                map["dateTime"] = dateTime
                map["title"] = title
                map["body"] = body
                map["image"] = image
        
                docRef.setData(map)
            print("updated")
        }
    }
}

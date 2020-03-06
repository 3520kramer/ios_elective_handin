//
//  CloudStorage.swift
//  MyNotebookCloud
//
//  Created by Oliver Kramer on 03/03/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class CloudStorage {
    
    static var noteList = [Note]()
    private static let db = Firestore.firestore()
    private static let storage = Storage.storage() // get the instance
    private static let notesCollection = "notes"
    private static let loginsCollection = "logins"
    
    // week 10
    static func downloadImage(name:String, vc:UIImageView){
        let imgRef = storage.reference(withPath: name) // get file handle
        // maxSixe = how big of an image should a user could download
        // makes sure that the file is downloaded before moving going in the "function"
        imgRef.getData(maxSize: 4000000){ (data, error) in
            if error == nil{
                print("success in dowloading img")
                
                let img = UIImage(data: data!)
                // Makes sure that we don't force it to do it
                // do it when there's time
                // a precaution to make sure that we don't interrupt another thread
                DispatchQueue.main.async { // prevent background thread from interrupting the main thread, which handles user input
                    vc.image = img
                }
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
    
    // listens for changes and updates if changes are made to db
    static func startListener(completion: @escaping ([Note]) -> ([Note])){
        print("starting listener")
        db.collection(notesCollection).addSnapshotListener { (snap, error ) in
            print("yes")
            if error == nil{
                self.noteList.removeAll()
                for note in snap!.documents {
                    let map = note.data()
                    
                    // Lige nu fucker den fordi den har gemt noget lokalt så den kan ikke læse ordenligt fra firebase
                    let dateTime = map["dateTime"] as! String
                    let title = map["title"] as! String
                    let text = map["text"] as! String

                    let newNote = Note(id: note.documentID, dateTime: dateTime, title: title, text: text)
                    self.noteList.append(newNote)
                }
                print(noteList[0].title)
                completion(noteList)
            }
        }
    }
    
    static func insertNote(){
        let docRef = db.collection(notesCollection).document()
        
        var map = [String:String]()
        map["title"] = "New note"
        map["dateTime"] = findDateTime()
        map["text"] = ""
        
        docRef.setData(map)
    }
    
    static func delete(id:String){
        // if you pass something in document parameter you will get that, if you doesn't pass anything (or a wrong id) it will get an empty
        let docRef = db.collection(notesCollection).document(id)
        docRef.delete()
    }
    
    static func update(id:String, dateTime: String, title:String, text:String){
        let docRef = db.collection(notesCollection).document(id)
        
        var map = [String:String]()
        map["dateTime"] = dateTime
        map["title"] = title
        map["text"] = text
        
        docRef.setData(map)
    }
    
}

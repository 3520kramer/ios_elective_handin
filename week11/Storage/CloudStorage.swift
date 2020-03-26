//
//  CloudStorage.swift
//  MyNotebookCloudPictures
//
//  Created by Oliver Kramer on 07/03/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import Foundation
import FirebaseStorage

class CloudStorage {

    private static let storage = Storage.storage() // get the instance

    static func downloadImage(name:String, note:Note, table:UITableView){
        let imgRef = storage.reference(withPath: name) // get file handle
        // maxSixe = how big of an image should a user could download
        // makes sure that the file is downloaded before moving going in the "function"
        imgRef.getData(maxSize: 4000000){ (data, error) in
            if error == nil{
                print("success in dowloading img: \(name)")
                
                let img = UIImage(data: data!)
                
                DispatchQueue.main.async { // prevent background thread from interrupting the main thread, which handles user input
                    note.uiimage = img
                    table.reloadData()
                }
            }else{
                print("Error: \(error.debugDescription)")
            }
        }
    }
    
    static func downloadImageFULL(name:String, note:Note, completion: @escaping () -> ()){
        let imgRef = storage.reference(withPath: name) // get file handle
        // maxSixe = how big of an image should a user could download
        // makes sure that the file is downloaded before moving going in the "function"
        imgRef.getData(maxSize: 4000000){ (data, error) in
            if error == nil{
                print("success in dowloading img: \(name)")
                
                let img = UIImage(data: data!)
                // Makes sure that we don't force it to do it
                // do it when there's time
                // a precaution to make sure that we don't interrupt another thread
                DispatchQueue.main.async { // prevent background thread from interrupting the main thread, which handles user input
                    note.uiimage = img
                    completion()
                    print("completion")
                }
            }else{
                print("Error: \(error.debugDescription)")
            }
        }
        
    }
    /*
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
    }*/
    
    // Date and time function
    static func findDateTime() -> String{
        // Creates a dateformatter and changes format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss_dd-MM-yyyy"
        
        // Creates a Date object to find the date and time
        let currDate = Date.init()
        
        // Returns string representation of date and time
        return dateFormatter.string(from: currDate)
    }
    
    static func uploadImage(data: Data) -> String{
        //let imgName = "picture_\(findDateTime()).jpg"
        let uuid = UUID().uuidString + ".jpg"
        let imgRef = storage.reference(withPath: uuid)
        imgRef.putData(data)
        return uuid
        
    }
}

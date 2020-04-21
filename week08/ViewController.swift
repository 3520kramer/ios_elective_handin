//
//  ViewController.swift
//  MyNotebookExpanded
//
//  Created by Oliver Kramer on 21/02/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var textView: UITextView!
    
    var myFile = "notes.txt"
    var currentNote = ""
    var noteIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = TableViewController.shared.noteArray[noteIndex]
    }
    
    // When pressing the back button this will get executed
    // Making sure that a change have been made before saving it to the array
    override func viewWillDisappear(_ animated: Bool) {
        if textView.text != TableViewController.shared.noteArray[noteIndex]{
            TableViewController.shared.noteArray[noteIndex] = textView.text
            saveArrayToFile(fileName: myFile)
        }else{
            print("No changes made, mate!")
        }
    }
    
    // When touching something outside of the keyboard, the keyboard is dismissed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           textView.resignFirstResponder()
    }
    
    // Function to save the whole array to a file
    func saveArrayToFile(fileName:String){
        let filePath = getDocumentDir().appendingPathComponent(fileName)
        do {
            try (TableViewController.shared.noteArray as NSArray).write(to: filePath)
            print("OK writing array to file: \(TableViewController.shared.noteArray)")
        } catch{
            print("Error writing array to file")
        }
    }
    
    func getDocumentDir() -> URL{
        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return documentDir[0]
    }
    
    
}


//
//  ViewController.swift
//  MyNotebookCloudCustomCell
//
//  Created by Oliver Kramer on 18/03/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var noteList = [Note]()
    private var selectedNote : Note?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        // if there's something in the list of notes, we clear it, so it's ready to be filled again
        if self.noteList.count > 0 {
            print("i remove all")
            self.noteList.removeAll()
        }
    
        tableView.delegate = self
        tableView.dataSource = self
        
        
        getNotes(first: true)

        
    }
    
    
    @IBAction func AddBtn(_ sender: Any) {
        selectedNote = CloudFirebase.insertNote()
        performSegue(withIdentifier: "showDetail", sender: nil)
        
    }
    // MARK: - Firebase
    
    func getNotes(first: Bool){
        // calling a function from CloudFirebase which listens for data to fill the array
        // the array is passed through the function from CloudFirebase, and can then be used here
        CloudFirebase.startListener(first: first){ (listFromDB) -> () in
            
            // for-each loop which iterates over the list
            for note in listFromDB{
                if note.image != "", let image = note.image{
                    CloudStorage.downloadImage(name: image, note: note, table: self.tableView)
                }
                self.noteList.append(note)
                
            }
        }
    }
    
    
    
    // MARK: - Table View Data
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = noteList[indexPath.row]
        
        if note.hasImage(){
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteWithPicture", for: indexPath) as! CellWithPicture
            if let title = note.title, let image = note.uiimage{
                cell.setCell(title: title, image: image)
            }
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteOnlyText", for: indexPath) as! CellOnlyText
            if let title = note.title{
                cell.setCell(title: title)
            }
            return cell
        }
        
}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let note = noteList[indexPath.row]
        if note.hasImage(){
            return 90
        }else{
            return 60
        }
    }
    
    // MARK: - Pagination
    
    // Function that checks if a particular cell is displayed
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // if indexPath(the index of cell rows) is the same as the lenght og our list then we need to load more content
        if indexPath.row == noteList.count - 1{
            getNotes(first: false)
        }
    }
    
    // MARK: - Segue
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNote = noteList[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let noteViewController = segue.destination as? NoteViewController{
            if let note = selectedNote{
                noteViewController.note = note
            }
        }
    }
    

}


//
//  TableViewController.swift
//  MyNotebookCloud
//
//  Created by Oliver Kramer on 03/03/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var currNote:Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CloudStorage.startListener { (noteList) -> ([Note]) in
            self.tableView.reloadData()
            return noteList
        }
        
        navigationItem.title = "Notes"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
            return CloudStorage.noteList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)

        // Sets each cell to the title of the note from our list
        cell.textLabel?.text = CloudStorage.noteList[indexPath.row].title

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Unpacks the id of the element to be deleted at the index of the selected row
            if let idAtIndex = CloudStorage.noteList[indexPath.row].id{
                
                // remove from array first so tableview knows how many rows it needs to update to
                CloudStorage.noteList.remove(at: indexPath.row)
                
                // Delete the row from the data source
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                // remove from database
                CloudStorage.delete(id: idAtIndex)
            }

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // This function selects the row from the table, and saves the data in a variable. then it performs the segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currNote = CloudStorage.noteList[indexPath.row]
        print(indexPath.row)
        
        // at the storyboard i named the segue 'showNote'
        performSegue(withIdentifier: "showNote", sender: nil)
    }
    
    @IBAction func newNoteBtn(_ sender: Any) {
    
        //var note = Note(id: "01",title: "MYTITLE", text: "MYTEXT")
        
        CloudStorage.insertNote()
        
        // at the storyboard i named the segue 'showNote'
        performSegue(withIdentifier: "showNote", sender: nil)
    }
    
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let viewController = segue.destination as? ViewController{
            if let currNote = currNote{
                viewController.note = currNote
            }
        }
    }
     
    
}

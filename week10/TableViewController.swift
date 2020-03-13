//
//  TableViewController.swift
//  MyNotebookCloudPictures
//
//  Created by Oliver Kramer on 07/03/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    private var noteList = [Note]()
    private var selectedNote: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // calling a function from CloudFirebase which listens for data to fill the array
        // the array is passed through the function from CloudFirebase, and can then be used here
        CloudFirebase.startListener { (arrayToPass) -> () in
            self.noteList = arrayToPass
            print("count: \(self.noteList.count)")
            self.tableView.reloadData()
            }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return noteList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = noteList[indexPath.row].title
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    
    @IBAction func addBtn(_ sender: Any) {
        CloudFirebase.insertNote()
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNote = noteList[indexPath.row]
        print("didSelectRowAt: \(indexPath.row)")
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let viewController = segue.destination as? ViewController{
            if let note = selectedNote{
                viewController.note = note
            }
        }
    }
}

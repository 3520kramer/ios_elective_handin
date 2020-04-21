//
//  TableViewController.swift
//  MyNotebookExpanded
//
//  Created by Oliver Kramer on 27/02/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    // Global variables
    struct shared {
        static var noteArray = [String]()
    }
    
    var myFile = "notes.txt"
    
    var noteIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shared.noteArray = readArrayFromFile(fileName: myFile)
        
        
        // UserDefaults for demo purpose - to show or hide the edit button
        // UserDefaults is often used to save lightweight usersettings
        // Saving large amounts of data in UserDefaults might make the app slow at startup
        let defaults = UserDefaults.standard
        
        defaults.set(true, forKey: "editBtnOption")
        defaults.synchronize()
        
        let showEditBtn = defaults.bool(forKey: "editBtnOption")
        
        if showEditBtn == true{
            self.navigationItem.leftBarButtonItem = self.editButtonItem
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // When touching the add button, a new note will be added
    // The index will be the last place of the array, as the new note has been appended
    // Lastly the segue is performed, where the index is sent to the ViewController
    @IBAction func addBtn(_ sender: Any) {
        shared.noteArray.append("new")
        noteIndex = shared.noteArray.count-1
        performSegue(withIdentifier: "showNote", sender: nil)
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows in table to be the length of the array
        return shared.noteArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)

        cell.textLabel?.text = shared.noteArray[indexPath.row]

        return cell
    }
    
    func getDocumentDir() -> URL{
        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return documentDir[0]
    }
    
    func readArrayFromFile(fileName:String) -> [String]{
        let filePath = getDocumentDir().appendingPathComponent(fileName)

        let array = NSArray(contentsOf: filePath) as! [String]
        
        return array
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            // remove from array first so tableview knows how many rows it needs to update to
            shared.noteArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
        noteIndex = indexPath.row
        
        // at the storyboard i named the segue 'showNote'
        performSegue(withIdentifier: "showNote", sender: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // If the typecasting of the segue's destination (in this case it should be a viewcontroller) is succesful, then we can send data to the viewcontroller
        if let viewController = segue.destination as? ViewController{
            viewController.noteIndex = noteIndex
        }
    }
    

}

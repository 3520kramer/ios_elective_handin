//
//  ViewController.swift
//  MyNotebook
//
//  Created by Oliver Kramer on 14/02/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var text = "Fill me up with text"
    var textArray = [String]() // we initialize an empty string array
    var edit = false
    var index = 0
    var fileName = "StringSaved.txt"

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() { // Only gets called once
        super.viewDidLoad()
        textArray.append("Hello")
        textArray.append("Hello again")
        textArray.append("This is new")
        tableView.dataSource = self
        tableView.delegate = self
        readStringFromFile(fileName: fileName)
    }
        
    override func viewWillAppear(_ animated: Bool) { // Gets called every time we go back to this page
        textView.text = text
    }
    
    // When touching something outside of the keyboard, the keyboard is dismissed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        text = textView.text // saves it in variable

        if edit == true {
            textArray[index] = text
            edit = false
        }else{
            textArray.append(text) // adds the text to the array
        }
        textView.text = ""
        tableView.reloadData()
        textView.resignFirstResponder()
        saveStringToFile(str: text, fileName: fileName)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") // gør det muligt at genbruge celler der er scrollet ud af fokus
        cell?.textLabel?.text = textArray[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textView.text = textArray[indexPath.row]
        edit = true
        index = indexPath.row
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        textArray.remove(at: index)
        textView.text = ""
        tableView.reloadData()

    }
    
    func saveStringToFile(str:String, fileName:String){
        let filePath = getDocumentDir().appendingPathComponent(fileName)
        do {
            try str.write(to: filePath, atomically: true, encoding: .utf8) // atomically er hvis man gerne vil have at ændringer til filen bliver neutraliseret hvis der sker fejl ved save
            print("OK writing string to file")
        } catch{
            print("Errro writing string to file")
        }
    }
    
    func getDocumentDir() -> URL{
        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return documentDir[0]
    }
    
    func readStringFromFile(fileName:String) -> String{
        let filePath = getDocumentDir().appendingPathComponent(fileName)
        
        do{
            let string = try String(contentsOf: filePath, encoding: .utf8)
            print(string)
            return string
        }catch{
            print("Error while reading file: " + fileName)
        }
        return "Empty"
    }
}


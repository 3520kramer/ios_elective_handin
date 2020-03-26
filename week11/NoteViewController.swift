//
//  NoteViewController.swift
//  MyNotebookCloudCustomCell
//
//  Created by Oliver Kramer on 21/03/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var image: UIImageView!

    
    var note: Note?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let note = note{
            titleTextField.text = note.title
            bodyTextView.text = note.body
            image.image = note.uiimage
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let note = note{
            note.title = titleTextField.text
            note.body = bodyTextView.text
        CloudFirebase.update(note: note)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

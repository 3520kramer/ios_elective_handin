//
//  ViewController.swift
//  MyNotebookCloudPictures
//
//  Created by Oliver Kramer on 06/03/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var imageSourceTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var note:Note?
    var picFromCam = false
    var newImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("wow")
        if let note = note {
            titleTextField.text = note.title
            dateTimeLabel.text = note.dateTime
            bodyTextView.text = note.body
            if let image = note.image, note.image != "empty"{
                imageSourceTextField.text = note.image
                CloudStorage.downloadImage(name: image, imageView: imageView)
            }else if note.image == "empty"{
                print("Note doesn't contain an image")
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let newImage = newImage, let imgJPG = newImage.jpegData(compressionQuality: 0.5), let note = note{
            note.image = CloudStorage.uploadImage(data: imgJPG)
            self.note = note
            
        }else if let note = note, let image = imageSourceTextField.text{
            note.image = image
            self.note = note
        }
        
        if let note = note{
            CloudFirebase.update(note: note)
        }
        
    }

    @IBAction func uploadImageBtn(_ sender: Any) {
        
        if imageSourceTextField.text == "new image - not in db yet"{
            print("Will upload when closing notes")
            
        }else if let note = note, let imageName = imageSourceTextField.text{
                note.image = imageName
                CloudStorage.downloadImage(name: imageName, imageView: imageView)
                
                CloudFirebase.update(note: note)
        }
        
    }

    @IBAction func cameraBtn(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            print("in camera if")
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            print("Picture from library: \(imagePicker.description)")
        }
    }
    
    @IBAction func photoLibraryBtn(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            print("in photolibrary if")
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            print("Picture from library: \(imagePicker.description)")
        }
    }
    
    // Function that executes when an image is picked from library (or camera?)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        }else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        }else {
            return
        }

        // sets the imageviews image to be the image chosen from the library and maybe camera
        imageView.image = newImage
        imageSourceTextField.text = "new image - not in db yet"
        dismiss(animated: true)
    }

}

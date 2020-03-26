//
//  CellWithPicture.swift
//  MyNotebookCloudCustomCell
//
//  Created by Oliver Kramer on 20/03/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit

class CellWithPicture: UITableViewCell {
    
    
    @IBOutlet weak var noteImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    func setCell(title:String, image:UIImage){
        print("set cell")
        
        titleLabel.text = title
        noteImage.image = image
    }
    
}

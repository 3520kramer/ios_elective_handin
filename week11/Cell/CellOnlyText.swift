//
//  CellOnlyText.swift
//  MyNotebookCloudCustomCell
//
//  Created by Oliver Kramer on 20/03/2020.
//  Copyright © 2020 Oliver Kramer. All rights reserved.
//

import UIKit

class CellOnlyText: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    func setCell(title:String){
        titleLabel.text = title
    }

}

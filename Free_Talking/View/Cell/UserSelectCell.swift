//
//  UserSelectCell.swift
//  Free_Talking
//
//  Created by 박진 on 2020/11/08.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit
import BEMCheckBox

class UserSelectCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: ProfileImage!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkBox: BEMCheckBox!
    
    func update(info: User, index: Int) {
        nameLabel.text = info.name
        imageView.setImage(with: info.imageUrl!)
        checkBox.tag = index
    }
}

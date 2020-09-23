//
//  GroupCell.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/16.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit

class GroupCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func update(info: Group) {
        titleLabel.text = info.name
    }
}


//
//  ChatCell.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/29.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit

class ChatCell: UICollectionViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    func update(info: Comment) {
        messageLabel.text = info.message
    }
}

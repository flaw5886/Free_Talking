//
//  ChatCell.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/29.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit

class MyChatCell: UICollectionViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var readLabel: UILabel!
    
    func update(info: Comment, userCount: Int) {
        messageLabel.text = info.message
        timeLabel.text = info.timestamp?.todayTime()
        
        if userCount > 0 {
            readLabel.isHidden = false
            readLabel.text = "\(userCount - info.readUsers.count)"
        } else {
            readLabel.isHidden = true
        }
        
    }
}

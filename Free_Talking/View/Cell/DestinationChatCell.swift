//
//  DestinationChatCell.swift
//  Free_Talking
//
//  Created by 박진 on 2020/10/05.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit

class DestinationChatCell: UICollectionViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImage: ProfileImage!
    
    func update(userInfo: User, commentInfo: Comment) {
        messageLabel.text = commentInfo.message
        timeLabel.text = commentInfo.timestamp?.todayTime()
        profileImage.image = userInfo.image
    }
}

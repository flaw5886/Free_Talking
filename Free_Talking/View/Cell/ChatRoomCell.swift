//
//  ChatRoomCell.swift
//  Free_Talking
//
//  Created by 박진 on 2020/10/06.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit

class ChatRoomCell: UICollectionViewCell {
    
    let firebaseService = FirebaseService.instance
    
    @IBOutlet weak var imageView: ProfileImage!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func update(chatInfo: Chat, user: User) {
        let last = chatInfo.comments.keys.sorted() {$0>$1}
        self.imageView.setImage(with: user.imageUrl!)
        self.nameLabel.text = user.name
        self.commentLabel.text = chatInfo.comments[last[0]]?.message
        self.timeLabel.text = chatInfo.comments[last[0]]?.timestamp?.todayTime()
    }
}

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
    @IBOutlet weak var alarmView: UIView!
    
    func update(chatInfo: Chat, user: User) {
        if chatInfo.comments.keys.count == 0 {
            return
        }
        
        let last = chatInfo.comments.keys.sorted() {$0>$1}
        
        if !last.isEmpty {
            let lastComment = chatInfo.comments[last[0]]
            self.imageView.setImage(with: user.imageUrl!)
            self.nameLabel.text = user.name
            self.commentLabel.text = lastComment?.message
            self.timeLabel.text = lastComment?.timestamp?.todayTime()
            
            if lastComment?.readUsers[self.firebaseService.currentUserUid!] == true {
                alarmView.isHidden = true
            } else {
                alarmView.isHidden = false
            }
        }
    }
}

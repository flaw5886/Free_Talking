//
//  ChatDetailViewModel.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/28.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase
import FirebaseStorage

class ChatDetailViewModel : BaseViewModel {
    
    let firebaseService = FirebaseService.instance
    
    let message = BehaviorRelay(value: "")
    let isEnabled = BehaviorRelay(value: true)
    
    var comments: [Comment] = []
    
    var destinationUid: String?
    var chatRoomUid: String?
    
    func checkChatRoom() {
        firebaseService.chatRoom
            .queryOrdered(byChild: "user/" + firebaseService.currentUserUid!)
            .queryEqual(toValue: true)
            .observeSingleEvent(of: DataEventType.value, with: { (dataSnapshot) in
                
                for item in dataSnapshot.children.allObjects as! [DataSnapshot] {
                    
                    if let chatRoomdic = item.value as? [String:AnyObject] {
                        let chat = Chat(JSON: chatRoomdic)
                        
                        if chat?.user[self.destinationUid!] == true {
                            self.chatRoomUid = item.key
                            self.isEnabled.accept(true)
                            self.getComments()
                        }
                    }
                }
            })
    }
    
    func createRoom() {
        let createRoomInfo: Dictionary<String,Any> = [
            "user": [
                firebaseService.currentUserUid!: true,
                destinationUid!: true
            ]
        ]
        
        if chatRoomUid == nil {
            // 방 생성
            self.isEnabled.accept(false)
            firebaseService.chatRoom.childByAutoId().setValue(createRoomInfo, withCompletionBlock: { (error, ref) in
                if error == nil {
                    self.checkChatRoom()
                }
            })
            
        } else {
            
            let value: Dictionary<String,Any> = [
                "uid": firebaseService.currentUserUid!,
                "message": self.message.value
            ]
            
            firebaseService.chatRoom.child(chatRoomUid!).child("comments").childByAutoId().setValue(value)
        }
    }
    
    func getComments() {
        firebaseService.chatRoom.child(chatRoomUid!).child("comments")
            .observe(DataEventType.value, with: { (dataSnapshot) in
            self.comments.removeAll()
            
            for item in dataSnapshot.children.allObjects as! [DataSnapshot] {
                let comment = Comment(JSON: item.value as! [String:AnyObject])
                self.comments.append(comment!)
            }
            self.isSuccess.accept(true)
        })
    }
}

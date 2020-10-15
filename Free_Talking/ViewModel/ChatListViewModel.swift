//
//  ChatListViewModel.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/16.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase
import FirebaseStorage

class ChatListViewModel : BaseViewModel {
    
    let firebaseService = FirebaseService.instance
    
    var chatList: [Chat] = []
    var uidList: [String] = []
    var nameList: [String] = []
    
    var destinationUid: String?
    
    func getChatList() {
        firebaseService.chatRoom.queryOrdered(byChild: "user/"+firebaseService.currentUserUid!).queryEqual(toValue: true)
            .observe(DataEventType.value, with: { (dataSnapshot) in
                self.chatList.removeAll()
                
                for item in dataSnapshot.children.allObjects as! [DataSnapshot] {
                    
                    if let chatroomdic = item.value as? [String:AnyObject] {
                        let chat = Chat(JSON: chatroomdic)
                        self.chatList.append(chat!)
                    }
                }
                self.isSuccess.accept(true)
                self.isLoading.accept(true)
            })
    }
    
    func getUid(index: Int) {
        for item in chatList[index].user {
            if item.key != firebaseService.currentUserUid {
                destinationUid = item.key
                self.uidList.append(destinationUid!)
            }
        }
    }
    
    func getUserInfo(data: DataSnapshot) -> User {
        let values = data.value as! [String:AnyObject]
        
        let user = User()
        user.name = values["name"] as? String ?? ""
        user.imageUrl = values["profileImageUrl"] as? String ?? ""
        user.uid = values["uid"] as? String ?? ""
        
        return user
    }
}

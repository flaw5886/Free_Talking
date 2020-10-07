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
}

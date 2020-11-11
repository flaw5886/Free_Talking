//
//  PeopleSelectViewModel.swift
//  Free_Talking
//
//  Created by 박진 on 2020/11/08.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase
import FirebaseStorage

class PeopleSelectViewModel: BaseViewModel {
    
    let firebaseService = FirebaseService.instance
    
    var userList: [User] = []
    var users = Dictionary<String, Bool>()
    
    func getAllUser() {
        let userRef = firebaseService.userRef
        userRef.observe(DataEventType.value, with: { (snapshot) in
            self.userList.removeAll()
            self.setUserList(data: snapshot)
            
            self.isSuccess.accept(true)
            self.isLoading.accept(true)
        })
    }
    
    func setUserList(data: DataSnapshot) {
        
        for child in data.children {
            let item = child as! DataSnapshot
            let values = item.value as! [String:Any]
            
            let user = User()
            user.name = values["name"] as? String ?? ""
            user.imageUrl = values["profileImageUrl"] as? String ?? ""
            user.uid = values["uid"] as? String ?? ""
            user.comment = values["comment"] as? String ?? ""
            
            if firebaseService.currentUserUid != user.uid {
                self.userList.append(user)
            }
        }
    }
    
    func createRoom() {
        users[firebaseService.currentUserUid!] = true
        
        let nsDic = users as NSDictionary
        
        firebaseService.chatRoom.childByAutoId().child("user").setValue(nsDic)
    }
}

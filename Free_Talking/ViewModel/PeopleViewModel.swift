//
//  HomeViewModel.swift
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

class PeopleViewModel : BaseViewModel {
    
    let firebaseService = FirebaseService.instance
    
    let name = BehaviorRelay(value: "")
    let comment = BehaviorRelay(value: "")
    let profileImageUrl = BehaviorRelay(value: "")
    let peopleCount = BehaviorRelay(value: "")
    
    var userList: [User] = []
    
    func getAllUser() {
        let userRef = firebaseService.userRef
        userRef.observe(DataEventType.value, with: { (snapshot) in
            self.userList.removeAll()
        
            for child in snapshot.children {
                let item = child as! DataSnapshot
                let values = item.value as! [String:Any]
                self.setUserList(values: values)
            }
            self.peopleCount.accept("친구 \(self.userList.count)명")
            self.isSuccess.accept(true)
            self.isLoading.accept(true)
        })
    }
    
    func setUserList(values: [String : Any]) {
        
        let name = values["name"] as? String ?? ""
        let profileImageUrl = values["profileImageUrl"] as? String ?? ""
        let uid = values["uid"] as? String ?? ""
        let comment = values["comment"] as? String ?? ""
        
        let user = User()
        user.name = name
        user.imageUrl = profileImageUrl
        user.uid = uid
        user.comment = comment
        
        if firebaseService.currentUserUid == uid {
            self.name.accept(user.name!)
            self.profileImageUrl.accept(user.imageUrl!)
            self.comment.accept(user.comment!)
        } else {
            self.userList.append(user)
        }
    }
}

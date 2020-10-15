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
            self.setUserList(data: snapshot)
            
            self.peopleCount.accept("친구 \(self.userList.count)명")
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
            
            if firebaseService.currentUserUid == user.uid {
                self.name.accept(user.name!)
                self.profileImageUrl.accept(user.imageUrl!)
                self.comment.accept(user.comment!)
            } else {
                self.userList.append(user)
            }
        }
        
    }
}

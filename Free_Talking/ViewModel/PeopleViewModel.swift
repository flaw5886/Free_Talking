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
    let profileImage = BehaviorRelay<UIImage?>(value: nil)
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
        
        let user = User()
        user.name = name
        user.image = profileImageUrl.getImage()
        user.uid = uid
        
        if firebaseService.currentUserUid == uid {
            self.name.accept(user.name!)
            self.profileImage.accept(user.image)
        } else {
            self.userList.append(user)
        }
    }
}

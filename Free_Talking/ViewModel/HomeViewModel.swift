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

class HomeViewModel : BaseViewModel {
    
    let firebaseService = FirebaseService.instance
    
    var userList: [User] = []
    
    func getAllUser() {
        let userRef = firebaseService.userRef
        userRef.observe(DataEventType.value, with: { (snapshot) in
            self.userList.removeAll()
        
            for child in snapshot.children {
                let item = child as! DataSnapshot
                let values = item.value as! [String: [String:Any]]
                self.setUserList(values: values)
            }
            
            self.isSuccess.accept(true)
            self.isLoading.accept(true)
        })
    }
    
    func setUserList(values: [String : [String : Any]]) {
        
        for index in values {
            let name = index.value["name"] as? String ?? ""
            let profileImageUrl = index.value["profileImageUrl"] as? String ?? ""
            
            let user = User()
            user.name = name
            user.profileImageUrl = profileImageUrl
            
            self.userList.append(user)
        }
    }
}

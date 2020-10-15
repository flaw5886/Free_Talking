//
//  ProfileViewModel.swift
//  Free_Talking
//
//  Created by 박진 on 2020/10/08.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase
import FirebaseStorage

class ProfileViewModel: BaseViewModel {

    let firebaseService = FirebaseService.instance
    
    var destinationUid: String?
    
    let name = BehaviorRelay(value: "")
    let comment = BehaviorRelay(value: "")
    let profileImageUrl = BehaviorRelay(value: "")
    let isHide = BehaviorRelay(value: false)
    
    func getUserInfo() {
        let userRef = firebaseService.userRef.child(destinationUid!)
        userRef.observe(.value, with: { (snapshot) in
            self.setUserInfo(data: snapshot)
            self.isLoading.accept(true)
        }) { (error) in
          print(error.localizedDescription)
      }
    }
    
    func setUserInfo(data: DataSnapshot) {
        let values = data.value as! [String:Any]
        
        let name = values["name"] as? String ?? ""
        let comment = values["comment"] as? String ?? ""
        let profileImageUrl = values["profileImageUrl"] as? String ?? ""
        
        self.name.accept(name)
        self.comment.accept(comment)
        self.profileImageUrl.accept(profileImageUrl)
    }
    
    func setComment(comment: String) {
        let dic = ["comment":comment]
        firebaseService.userRef.child(firebaseService.currentUserUid!).updateChildValues(dic)
    }
}

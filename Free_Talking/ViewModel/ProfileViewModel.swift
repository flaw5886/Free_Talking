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
            
            let values = snapshot.value
            self.setUserInfo(values: values as! [String:Any])
            
            self.isLoading.accept(true)
        }) { (error) in
          print(error.localizedDescription)
      }
    }
    
    func setUserInfo(values: [String : Any]) {
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

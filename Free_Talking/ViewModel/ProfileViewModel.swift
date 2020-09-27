//
//  ProfileViewModel.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/23.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase
import FirebaseStorage

class ProfileViewModel : BaseViewModel {
    
    let email = BehaviorRelay(value: "")
    let name = BehaviorRelay(value: "")
    let profileImage = BehaviorRelay<UIImage?>(value: nil)
    
    let firebaseService = FirebaseService.instance
    
    func getUserInfo() {
        let uid = firebaseService.currentUserUid
        let userRef = firebaseService.userRef.child(uid!)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let values = snapshot.value
            self.setUserInfo(values: values as! [String: [String:Any]])
        }) { (error) in
          print(error.localizedDescription)
      }
    }
    
    func setUserInfo(values: [String : [String : Any]]) {
        let email = self.firebaseService.currentUserEmail!
        var name = ""
        var profileImageUrl = ""
        
        for index in values {
            name = index.value["name"] as? String ?? ""
            profileImageUrl = index.value["profileImageUrl"] as? String ?? ""
        }
        
        let url = URL(string: profileImageUrl)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        
        self.email.accept(email)
        self.name.accept(name)
        self.profileImage.accept(image)
        
        self.isSuccess.accept(true)
    }
}

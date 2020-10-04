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
    
    let firebaseService = FirebaseService.instance
    
    let email = BehaviorRelay(value: "")
    let name = BehaviorRelay(value: "")
    let profileImage = BehaviorRelay<UIImage?>(value: nil)
    
    func getUserInfo() {
        let uid = firebaseService.currentUserUid
        let userRef = firebaseService.userRef.child(uid!)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let values = snapshot.value
            self.setUserInfo(values: values as! [String:Any])
            
            self.isSuccess.accept(true)
            self.isLoading.accept(true)
            
        }) { (error) in
          print(error.localizedDescription)
      }
    }
    
    func setUserInfo(values: [String : Any]) {
        let email = self.firebaseService.currentUserEmail!
        let name = values["name"] as? String ?? ""
        let profileImageUrl = values["profileImageUrl"] as? String ?? ""
        
        DispatchQueue.global().async {
            let url = URL(string: profileImageUrl)
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                self.profileImage.accept(image)
            }
        }
        self.email.accept(email)
        self.name.accept(name)
    }
}

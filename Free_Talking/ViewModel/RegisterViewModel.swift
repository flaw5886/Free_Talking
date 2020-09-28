//
//  RegisterViewModel.swift
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

class RegisterViewModel: BaseViewModel {
    
    let firebaseService = FirebaseService.instance
    
    let email = BehaviorRelay(value: "")
    let pw = BehaviorRelay(value: "")
    let name = BehaviorRelay(value: "")
    let profileImage = BehaviorRelay<UIImage?>(value: nil)
    
    func register() {
        Auth.auth().createUser(withEmail: email.value, password: pw.value) { (user, error) in
            let uid = user?.user.uid
            let imageRef = self.firebaseService.userImageRef.child(uid!)
            let userRef = self.firebaseService.userRef.child(uid!)
            
            let userImage = self.profileImage.value!.jpegData(compressionQuality: 0.1)
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
                
            imageRef.putData(userImage!, metadata: metadata, completion: { (data, error) in
                imageRef.downloadURL(completion: { (url, error) in
                    
                    let value = ["name":self.name.value, "profileImageUrl":url?.absoluteString]
                    userRef.child(uid!).setValue(value, withCompletionBlock: { (error, ref) in
                        if error == nil {
                            self.isSuccess.accept(true)
                        }
                    })
                })
            })
        }
    }
}

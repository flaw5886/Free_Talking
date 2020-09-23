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
    
    let email = BehaviorRelay(value: "")
    let pw = BehaviorRelay(value: "")
    let name = BehaviorRelay(value: "")
    var image: UIImage? = nil
    
    func setImage(image: UIImage) {
        self.image = image
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email.value, password: pw.value) { (user, error) in
            if user != nil {
                let userImage = self.image?.jpegData(compressionQuality: 0.1)
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
    
                let uid = user?.user.uid
                let imageRef = Storage.storage().reference().child("userImages").child(uid!)
                let userRef = Database.database().reference().child("user").child(uid!)
                    
                imageRef.putData(userImage!, metadata: metadata, completion: { (data, error) in
                    imageRef.downloadURL(completion: { (url, error) in
                        userRef.child(uid!).setValue(["name":self.name.value, "profileImageUrl":url?.absoluteString])
                    })
                })
                
                self.isSuccess.accept(true)
            } else {
                self.isError.accept(true)
            }
        }
    }
}

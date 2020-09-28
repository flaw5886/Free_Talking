//
//  FirebaseService.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/16.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

fileprivate let dataBaseRef = Database.database().reference()
fileprivate let storageRef = Storage.storage().reference()

class FirebaseService {
    static let instance = FirebaseService()
    
    // 사용자
    let userRef = dataBaseRef.child("user")
    
    // 사용자 사진
    let userImageRef = storageRef.child("userImages")
    
    // 현재 유저 id
    var currentUserUid: String? {
            get {
                guard let uid = Auth.auth().currentUser?.uid else {
                    return nil
                }
                return uid
            }
        }
    
    // 현재 유저 email
    var currentUserEmail: String? {
        get {
            guard let email = Auth.auth().currentUser?.email else {
                return nil
            }
            return email
        }
    }
}

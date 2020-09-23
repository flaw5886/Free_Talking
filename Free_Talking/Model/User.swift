//
//  User.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/16.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import Foundation

// 사용자
struct User {
    var uid: String
    var email: String
    var username: String
    var group: Dictionary<String, String>
    
    init(uid: String, email: String, username: String) {
        self.uid = uid
        self.email = email
        self.username = username
        self.group = [:]
    }
}

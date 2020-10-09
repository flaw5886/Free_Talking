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
    var destinationName: String?
    var destinationImageUrl: String?
    
    let name = BehaviorRelay(value: "")
    let profileImageUrl = BehaviorRelay(value: "")
    let isHide = BehaviorRelay(value: false)
    
    func setProfile() {
        name.accept(destinationName!)
        profileImageUrl.accept(destinationImageUrl!)
    }
}

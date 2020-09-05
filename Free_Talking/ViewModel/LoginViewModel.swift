//
//  LoginViewModel.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/04.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

class LoginViewModel : BaseViewModel {
    
    let email = BehaviorRelay(value: "")
    let pw = BehaviorRelay(value: "")
    
    func login() {
        isLoading.accept(true)
        
        Auth.auth().signIn(withEmail: email.value, password: pw.value) { (user, error) in
            if (user != nil) {
                self.isSuccess.accept(true)
            } else {
                self.isError.accept(true)
            }
            self.isLoading.accept(false)
        }
    }
}

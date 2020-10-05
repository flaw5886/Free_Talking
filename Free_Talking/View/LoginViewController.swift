//
//  ViewController.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/04.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    let viewModel = LoginViewModel()
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func initUI() {
        loginButton.layer.cornerRadius = 8
    }
    
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) { }
    
    override func configureCallback() {
        viewModel.isSuccess.bind { value in
            if value {
                self.performSegue(withIdentifier: "showMain", sender: nil)
            }
        }.disposed(by: disposeBag)
        
        viewModel.isLoading.bind { value in
            if value {
                self.startIndicatingActivity()
            } else {
                self.stopIndicatingActivity()
            }
        }.disposed(by: disposeBag)
        
        viewModel.isError.bind { value in
            if value {
                self.warningAlert(title: "로그인 실패", message: "이메일 또는 비밀번호가 일치하지 않습니다")
            }
        }.disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        emailField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        pwField.rx.text.orEmpty
            .bind(to: viewModel.pw)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(onNext: viewModel.login)
            .disposed(by: disposeBag)
    }
}


//
//  ProfileViewController.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/23.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MenuViewController: BaseViewController {
    
    let viewModel = MenuViewModel()
    
    @IBOutlet weak var imageView: ProfileImage!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func initUI() {
        logoutButton.layer.cornerRadius = 8
        viewModel.getUserInfo()
    }
    
    override func configureCallback() {
        viewModel.isLoading.bind { value in
            if value {
                self.stopIndicatingActivity()
            } else {
                self.startIndicatingActivity()
            }
        }.disposed(by: disposeBag)
        
        viewModel.isSuccess.bind { value in
            if value {
                self.performSegue(withIdentifier: "unwindToLogin", sender: nil)
            }
        }.disposed(by: disposeBag)
        
        viewModel.profileImageUrl.bind { value in
            self.imageView.setImage(with: value)
        }.disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        viewModel.email
            .bind(to: self.emailLabel.rx.text)
            .disposed(by: disposeBag)
            
        viewModel.name
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .bind(onNext: viewModel.logout)
            .disposed(by: disposeBag)
    }
}

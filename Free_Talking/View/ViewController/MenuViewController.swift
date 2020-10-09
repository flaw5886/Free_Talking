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
    
    override func initUI() {
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
    }
}

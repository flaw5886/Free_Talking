//
//  ProfileViewController.swift
//  Free_Talking
//
//  Created by 박진 on 2020/10/08.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    let viewModel = ProfileViewModel()
    
    @IBOutlet weak var imageView: ProfileImage!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var chatLabel: UILabel!
    
    override func initUI() {
        viewModel.setProfile()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChat" {
            let vc = segue.destination as? ChatDetailViewController
            
            vc?.viewModel.destinationUid = self.viewModel.destinationUid
            vc?.viewModel.destinationName = self.viewModel.destinationName
        }
    }
    
    override func configureCallback() {
        viewModel.profileImageUrl.bind { value in
            self.imageView.setImage(with: value)
        }.disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        viewModel.name
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isHide
            .bind(to: self.chatButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isHide
            .bind(to: self.chatLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        chatButton.rx.tap
            .bind(onNext: self.moveToChat)
            .disposed(by: disposeBag)
    }
    
    func moveToChat() {
        self.performSegue(withIdentifier: "showChat", sender: nil)
    }
}

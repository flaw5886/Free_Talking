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
    
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var imageView: ProfileImage!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func initUI() {
        viewModel.getUserInfo()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChat" {
            let vc = segue.destination as? ChatDetailViewController
            
            vc?.viewModel.destinationUid = self.viewModel.destinationUid
            vc?.viewModel.destinationName = self.viewModel.name.value
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
        
        viewModel.comment
            .bind(to: self.commentLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isHide
            .bind(to: self.chatButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        chatButton.rx.tap
            .bind(onNext: self.moveToChat)
            .disposed(by: disposeBag)
        
        viewModel.isHide
            .bind(to: self.editButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        editButton.rx.tap
            .bind(onNext: self.showAlert)
            .disposed(by: disposeBag)
    }
    
    func moveToChat() {
        self.performSegue(withIdentifier: "showChat", sender: nil)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "상태 메세지", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (text) in
            text.placeholder = "상태 메세지를 입력해주세요"
        }
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
            
            if let textField = alert.textFields?.first {
                self.viewModel.setComment(comment: textField.text!)
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

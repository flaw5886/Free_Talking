//
//  ChatDetailViewController.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/28.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit

class ChatDetailViewController: BaseViewController {
    
    let viewModel = ChatDetailViewModel()
    
    @IBOutlet weak var chatField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func initUI() {
        viewModel.checkChatRoom()
    }
    
    override func configureCallback() {
        viewModel.isSuccess.bind { value in
            if value {
                self.collectionView.reloadData()
            }
        }.disposed(by: disposeBag)
        
        viewModel.isReset.bind { value in
            if value {
                self.chatField.text = ""
            }
        }.disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        sendButton.rx.tap
            .bind(onNext: viewModel.createRoom)
            .disposed(by: disposeBag)
        
        viewModel.isEnabled
            .bind(to: sendButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        chatField.rx.text.orEmpty
            .bind(to: viewModel.message)
            .disposed(by: disposeBag)
    }
}

extension ChatDetailViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if viewModel.comments[indexPath.item].uid == viewModel.firebaseService.currentUserUid {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyChatCell", for: indexPath)
                as? MyChatCell else {
                return UICollectionViewCell()
            }
            cell.layer.cornerRadius = 8
            cell.update(info: viewModel.comments[indexPath.item])
            
            return cell
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DestinationChatCell", for: indexPath)
                as? DestinationChatCell else {
                return UICollectionViewCell()
            }
            cell.layer.cornerRadius = 8
            if viewModel.user.name != nil {
                cell.update(userInfo: viewModel.user, commentInfo: viewModel.comments[indexPath.item])
            }
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

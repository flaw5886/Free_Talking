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
    
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var chatField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var restoreFrameValue: CGFloat = 0.0
    
    override func initUI() {
        navigation.title = viewModel.destinationName
        viewModel.checkChatRoom()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func configureCallback() {
        viewModel.isSuccess.bind { value in
            if value {
                self.collectionView.reloadData()
                self.scrollToBottomAnimated(animated: true)
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
    
    func scrollToBottomAnimated(animated: Bool) {
            guard self.collectionView.numberOfSections > 0 else {
                return
            }

            let items = self.collectionView.numberOfItems(inSection: 0)
            if items == 0 { return }

            let collectionViewContentHeight = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            let isContentTooSmall: Bool = (collectionViewContentHeight < self.collectionView.bounds.size.height)

            if isContentTooSmall {
                self.collectionView.scrollRectToVisible(CGRect(x: 0, y: collectionViewContentHeight - 1, width: 1, height: 1), animated: animated)
                return
            }

            self.collectionView.scrollToItem(at: NSIndexPath(item: items - 1, section: 0) as IndexPath, at: .bottom, animated: animated)
        }
}

extension ChatDetailViewController: UITextFieldDelegate {
        
        @objc func keyboardWillAppear(noti: NSNotification) {
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.origin.y -= keyboardHeight
            }
        }
        
        @objc func keyboardWillDisappear(noti: NSNotification) {
            if self.view.frame.origin.y != restoreFrameValue {
                if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardRectangle = keyboardFrame.cgRectValue
                    let keyboardHeight = keyboardRectangle.height
                    self.view.frame.origin.y += keyboardHeight
                }
            }
        }
}

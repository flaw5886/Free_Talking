//
//  ChatDetailViewController.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/28.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit

class ChatViewController: BaseViewController {
    
    let viewModel = ChatViewModel()
    
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var chatField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var viewConstraints: NSLayoutConstraint!
    
    override func initUI() {
        initData(constraints: viewConstraints)
        navigation.title = viewModel.destinationName
        viewModel.checkChatRoom()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.removeObserve()
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

extension ChatViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.95, height: 50)
    }
    
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
            
            if self.viewModel.peopleCount != nil {
                cell.update(info: self.viewModel.comments[indexPath.item], userCount: self.viewModel.peopleCount!)
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DestinationChatCell", for: indexPath)
                as? DestinationChatCell else {
                return UICollectionViewCell()
            }
            cell.layer.cornerRadius = 8
            
            if self.viewModel.user.name != nil && self.viewModel.peopleCount != nil {
                cell.update(userInfo: self.viewModel.user, userCount: self.viewModel.peopleCount!, commentInfo: self.viewModel.comments[indexPath.item])
            }
        
            return cell
        }
    }
}


extension ChatViewController {
    
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

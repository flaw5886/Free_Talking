//
//  ChatListViewController.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/16.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ChatListViewController: BaseViewController {
    
    let viewModel = ChatListViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func initUI() {
        viewModel.getChatList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChat" {
            let vc = segue.destination as? ChatDetailViewController
            
            if let index = sender as? Int {
                vc?.viewModel.destinationUid = self.viewModel.uidList[index]
                vc?.viewModel.destinationName = self.viewModel.nameList[index]
            }
        }
    }
    
    override func configureCallback() {
        viewModel.isSuccess.bind { value in
            if value {
                self.collectionView.reloadData()
            }
        }.disposed(by: disposeBag)
        
        viewModel.isLoading.bind { value in
            if value {
                self.stopIndicatingActivity()
            } else {
                self.startIndicatingActivity()
            }
        }.disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        
    }
}


extension ChatListViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.95, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.chatList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatRoomCell", for: indexPath)
            as? ChatRoomCell else {
            return UICollectionViewCell()
        }
        cell.layer.cornerRadius = 8
        
        let alarmView = cell.alarmView!
        alarmView.layer.cornerRadius = alarmView.frame.size.height/2
        alarmView.layer.masksToBounds = true
        
        viewModel.getUid(index: indexPath.item)
        
        if let uid = self.viewModel.destinationUid {
            viewModel.firebaseService.userRef.child(uid)
                .observe(DataEventType.value, with: { (dataSnapshot) in
                    
                    let user = self.viewModel.getUserInfo(data: dataSnapshot)
                    self.viewModel.nameList.append(user.name!)
                    cell.update(chatInfo: self.viewModel.chatList[indexPath.item], user: user)
                })
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showChat", sender: indexPath.item)
    }
}


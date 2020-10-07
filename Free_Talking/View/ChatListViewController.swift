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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.chatList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatRoomCell", for: indexPath)
            as? ChatRoomCell else {
            return UICollectionViewCell()
        }
        cell.layer.cornerRadius = 8
        
        var destinationUid: String?
        
        for item in viewModel.chatList[indexPath.item].user {
            if item.key != viewModel.firebaseService.currentUserUid {
                destinationUid = item.key
                viewModel.uidList.append(destinationUid!)
            }
        }
        
        viewModel.firebaseService.userRef.child(destinationUid!)
            .observe(DataEventType.value, with: { (dataSnapshot) in
                
                let values = dataSnapshot.value as! [String:AnyObject]
                let name = values["name"] as? String ?? ""
                let profileImageUrl = values["profileImageUrl"] as? String ?? ""
                let uid = values["uid"] as? String ?? ""
            
                let user = User()
                user.name = name
                user.image = profileImageUrl.getImage()
                user.uid = uid
                
                print(user.name!)
                
                self.viewModel.nameList.append(name)
                cell.update(chatInfo: self.viewModel.chatList[indexPath.item], user: user)
            })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showChat", sender: indexPath.item)
    }
}


//
//  ChatListViewController.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/16.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit

class ChatListViewController: BaseViewController {
    
    let viewModel = ChatListViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func initUI() {
        
    }
    
    override func configureCallback() {
        viewModel.isSuccess.bind { value in
            if value {
                self.collectionView.reloadData()
            }
        }.disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        
    }
}


extension ChatListViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath)
            as? GroupCell else {
            return UICollectionViewCell()
        }
        cell.layer.cornerRadius = 8
        // cell.update(info: )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


//
//  HomeViewController.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/16.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    let viewModel = HomeViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func initUI() {
        viewModel.getAllUser()
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

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.userList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath)
            as? UserCell else {
            return UICollectionViewCell()
        }
        cell.layer.cornerRadius = 8
        cell.update(info: viewModel.userList[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

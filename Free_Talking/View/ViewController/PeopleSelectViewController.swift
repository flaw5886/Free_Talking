//
//  PeopleSelectViewController.swift
//  Free_Talking
//
//  Created by 박진 on 2020/11/08.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit
import BEMCheckBox

class PeopleSelectViewController: BaseViewController {
    
    let viewModel = PeopleSelectViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var checkButton: UIBarButtonItem!
    
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
        checkButton.rx.tap
            .bind(onNext: viewModel.createRoom)
            .disposed(by: disposeBag)
    }
}

extension PeopleSelectViewController: BEMCheckBoxDelegate {
    
    func didTap(_ checkBox: BEMCheckBox) {
        let uid = self.viewModel.userList[checkBox.tag].uid!
        
        if checkBox.on {
            self.viewModel.users[uid] = true
        } else {
            self.viewModel.users.removeValue(forKey: uid)
        }
    }
}

extension PeopleSelectViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.95, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.userList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserSelectCell", for: indexPath)
            as? UserSelectCell else {
            return UICollectionViewCell()
        }
        cell.layer.cornerRadius = 8
        cell.update(info: viewModel.userList[indexPath.item], index: indexPath.item)
        
        return cell
    }
}

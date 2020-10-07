//
//  HomeViewController.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/16.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit

class PeopleViewController: BaseViewController {
    
    let viewModel = PeopleViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: ProfileImage!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var peopleCountLabel: UILabel!
    
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
        viewModel.name
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.profileImage
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.peopleCount
            .bind(to: peopleCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChat" {
            let vc = segue.destination as? ChatDetailViewController
            
            if let index = sender as? Int {
                let user = self.viewModel.userList[index]
                vc?.viewModel.destinationUid = user.uid
                vc?.viewModel.destinationName = user.name
            }
        }
    }
}

extension PeopleViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        performSegue(withIdentifier: "showChat", sender: indexPath.item)
    }
}

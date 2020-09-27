//
//  RegisterViewController.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/21.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {
    
    let viewModel = RegisterViewModel()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func initUI() {
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        imageView.layer.masksToBounds = true
        addImageButton.layer.cornerRadius = 8
        registerButton.layer.cornerRadius = 8
        viewModel.setImage(image: self.imageView.image!)
    }
    
    override func configureCallback() {
        viewModel.isSuccess.bind { value in
            if value {
                self.performSegue(withIdentifier: "unwindToLogin", sender: nil)
            }
        }.disposed(by: disposeBag)
        
        viewModel.isError.bind { value in
            if value {
                self.present(self.standardAlert(title: "실패!", message: "회원가입 실패", actionTitle: "확인"),
                             animated: true, completion: nil)
            }
        }.disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        emailField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        pwField.rx.text.orEmpty
            .bind(to: viewModel.pw)
            .disposed(by: disposeBag)
        
        nameField.rx.text.orEmpty
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)
        
        addImageButton.rx.tap
            .bind(onNext: self.imagePicker)
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .bind(onNext: viewModel.register)
            .disposed(by: disposeBag)
    }
}

extension RegisterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        viewModel.setImage(image: self.imageView.image!)
        dismiss(animated: true, completion: nil)
    }
}

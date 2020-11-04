//
//  BaseViewController.swift
//  Moment_Plan
//
//  Created by 박진 on 2020/08/22.
//  Copyright © 2020 kr.hs.dgsw.momentplan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController : UIViewController {
    
    @IBOutlet weak var constraints: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        configureCallback()
        bindViewModel()
        
        if constraints != nil {
            addKeyboardNotification()
        }
    }
    
    func initUI() { }
    
    func initData(constraints: NSLayoutConstraint) {
        self.constraints = constraints
    }
    
    func configureCallback() { }
    
    func bindViewModel() { }
    
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keybordSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else{
                return
        }
        
        var safeBot: CGFloat = 0
        if let uBot = UIApplication.shared.windows.first?.safeAreaInsets.bottom { safeBot = uBot }
        let newHeight: CGFloat = keybordSize.height - safeBot
        
        UIView.setAnimationsEnabled(false)
        self.constraints.constant = newHeight + 20
        self.view.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification){
        
        UIView.setAnimationsEnabled(false)
        self.constraints.constant = 20
        self.view.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
}



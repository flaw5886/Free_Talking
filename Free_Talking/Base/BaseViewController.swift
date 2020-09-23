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
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        configureCallback()
        bindViewModel()
    }
    
    func initUI() { }
    
    func configureCallback() { }
    
    func bindViewModel() { }
    
    func standardAlert(title: String, message: String, actionTitle: String) -> UIAlertController {
        
        let alert = UIAlertController(
        title: title,
        message: message,
        preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: actionTitle,
            style: .default,
            handler: nil)
        
        alert.addAction(action)
        
        return alert
    }
}



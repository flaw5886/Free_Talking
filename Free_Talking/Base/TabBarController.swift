//
//  TabBarController.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/06.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
}

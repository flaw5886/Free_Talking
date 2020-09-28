//
//  ProfileImage.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/28.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit

class ProfileImage: UIImageView {
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = true
    }
}

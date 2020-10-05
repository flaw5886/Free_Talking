//
//  User.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/28.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit

class User {
    var name: String?
    var image: UIImage?
    var uid: String?
}

extension String {
    
    func getImage() -> UIImage {
        let url = URL(string: self)
        let data = try? Data(contentsOf: url!)
        return UIImage(data: data!)!
    }
}

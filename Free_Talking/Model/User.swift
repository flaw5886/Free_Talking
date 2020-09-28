//
//  User.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/28.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject {
    var name: String?
    var profileImageUrl: String?
}

extension User {
    
    // url을 이미지로 변환
    func getImage() -> UIImage {
        let url = URL(string: profileImageUrl ?? "")
        let data = try? Data(contentsOf: url!)
        return UIImage(data: data!)!
    }
}

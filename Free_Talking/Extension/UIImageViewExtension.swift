//
//  UIImageViewExtension.swift
//  Free_Talking
//
//  Created by 박진 on 2020/10/09.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(with urlString: String) {
        if urlString != "" {
            let cache = ImageCache.default
            cache.retrieveImage(forKey: urlString, options: nil) { (image, _) in // 캐시에서 키를 통해 이미지를 가져온다.
                if let image = image { // 만약 캐시에 이미지가 존재한다면
                    self.image = image // 바로 이미지를 셋한다.
                } else {
                    let url = URL(string: urlString) // 캐시가 없다면
                    let resource = ImageResource(downloadURL: url!, cacheKey: urlString) // URL로부터 이미지를 다운받고 String 타입의 URL을 캐시키로 지정하고
                    self.kf.setImage(with: resource) // 이미지를 셋한다.
                }
            }
        }
    }
    
}

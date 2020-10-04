//
//  Chat.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/28.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import ObjectMapper

class Chat: Mappable {
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user <- map["user"]
        comments <- map["comments"]
    }

    var user: Dictionary<String, Bool> = [:] // 채팅방에 참여한 사람들
    var comments: Dictionary<String, Comment> = [:] // 채팅방의 내용
}

class Comment: Mappable {
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        uid <- map["uid"]
    }
    
    var message: String?
    var uid: String?
}

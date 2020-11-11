//
//  ChatDetailViewModel.swift
//  Free_Talking
//
//  Created by 박진 on 2020/09/28.
//  Copyright © 2020 com.parkjin.free_talking. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase
import FirebaseStorage

class ChatViewModel : BaseViewModel {
    
    let firebaseService = FirebaseService.instance
    
    let message = BehaviorRelay(value: "")
    let isEnabled = BehaviorRelay(value: true)
    let isReset = BehaviorRelay(value: false)
    
    var comments: [Comment] = []
    let user = User()
    
    var destinationUid: String?
    var destinationName: String?
    var chatRoomUid: String?
    
    var peopleCount: Int?
    
    var databaseRef: DatabaseReference?
    var observe: UInt?
    
    func checkChatRoom() {
        firebaseService.chatRoom
            .queryOrdered(byChild: "user/" + firebaseService.currentUserUid!)
            .queryEqual(toValue: true)
            .observeSingleEvent(of: DataEventType.value, with: { (dataSnapshot) in
                
                for item in dataSnapshot.children.allObjects as! [DataSnapshot] {
                    
                    if let chatRoomdic = item.value as? [String:AnyObject] {
                        let chat = Chat(JSON: chatRoomdic)
                        
                        if chat?.user[self.destinationUid!] == true && chat?.user.count == 2 {
                            self.chatRoomUid = item.key
                            self.isEnabled.accept(true)
                            self.getDestinationInfo()
                        }
                    }
                }
            })
    }
    
    func createRoom() {
        if chatRoomUid == nil { // 방 생성
            self.isEnabled.accept(false)
            
            let createRoomInfo: Dictionary<String,Any> = [
                "user": [
                    firebaseService.currentUserUid!: true,
                    destinationUid!: true
                ]
            ]
            
            firebaseService.chatRoom.childByAutoId().setValue(createRoomInfo, withCompletionBlock: { (error, ref) in
                if error == nil {
                    self.checkChatRoom()
                }
            })
            
        } else {
            
            let value: Dictionary<String,Any> = [
                "uid": firebaseService.currentUserUid!,
                "message": self.message.value,
                "timestamp": ServerValue.timestamp()
            ]
            
            self.isReset.accept(true)
            firebaseService.chatRoom.child(chatRoomUid!).child("comments").childByAutoId().setValue(value)
        }
    }
    
    func getDestinationInfo() {
        firebaseService.userRef.child(destinationUid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value as! [String:Any]
            
            self.user.name = values["name"] as? String ?? ""
            self.user.imageUrl = values["profileImageUrl"] as? String ?? ""
        
            self.getUserCount()
        })
    }
    
    func getUserCount() {
        firebaseService.chatRoom.child(chatRoomUid!).child("user").observeSingleEvent(of: .value, with: { (dataSnapshot) in
            let dic = dataSnapshot.value as! [String:Any]
            
            if self.peopleCount == nil {
                self.peopleCount = dic.count
            }
        })
        self.getComments()
    }
    
    func getComments() {
        databaseRef = firebaseService.chatRoom.child(chatRoomUid!).child("comments")
        observe = databaseRef?.observe(DataEventType.value, with: { (dataSnapshot) in
            self.comments.removeAll()
            
            var readUserDic: Dictionary<String, AnyObject> = [:]
        
            for item in dataSnapshot.children.allObjects as! [DataSnapshot] {
                let comment = Comment(JSON: item.value as! [String:AnyObject])
                self.comments.append(comment!)
                
                let commentMotify = Comment(JSON: item.value as! [String:AnyObject])
                commentMotify?.readUsers[self.firebaseService.currentUserUid!] = true
                
                let key = item.key as String
                readUserDic[key] = (commentMotify?.toJSON())! as NSDictionary
            }
            self.setReadUser(nsDic: readUserDic as NSDictionary, data: dataSnapshot)
        })
    }
    
    func setReadUser(nsDic: NSDictionary, data: DataSnapshot) {
        
        if self.comments.last?.readUsers == nil {
            return
        }
        
        if (!(self.comments.last?.readUsers.keys.contains(self.firebaseService.currentUserUid!))!) {
            data.ref.updateChildValues(nsDic as! [AnyHashable : Any], withCompletionBlock: { (error, ref) in
                if error == nil {
                    self.isSuccess.accept(true)
                }
            })
        } else {
            self.isSuccess.accept(true)
        }
    }
    
    func removeObserve() {
        databaseRef?.removeObserver(withHandle: observe!)
    }
}

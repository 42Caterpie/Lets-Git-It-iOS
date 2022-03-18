//
//  CompetitionMainViewModel.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/21.
//

import Foundation
import Firebase

class CompetitionService: ObservableObject {
    @Published var roomDatas: [RoomData] = []
    @Published var joinError: String = " "
    @Published var isJoinable: Bool = false
    let db = Firestore.firestore()
    let userID = UserDefaults.shared.string(forKey: "userId") ?? Auth.auth().currentUser?.uid ?? "none"
    
    init () {
        requestRoomDatas()
    }
    
    func requestRoomDatas() {
        self.roomDatas = []
        db.collection("RoomData").whereField("participants", arrayContains: userID).getDocuments() { querySnapshot, error in
            if let error = error {
                print(error)
            }
            else {
                let decoder = JSONDecoder()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let jsonData = try? JSONSerialization.data(withJSONObject:data)
                    let roomInfo = try? decoder.decode(RoomData.self, from: jsonData!)
                    guard let roomInfo = roomInfo else { return }
                    self.roomDatas.append(roomInfo)
                }
            }
        }
    }
    
    func createRoom(with roomData: RoomData) {
        validRoomIDtoMake() { roomID in
            let roomData = RoomData(id: roomID,
                                    title: roomData.title,
                                    startDate: roomData.startDate,
                                    goal: roomData.goal,
                                    participants: [self.userID],
                                    maxParticipants: roomData.maxParticipants).asDictionary!
            self.db.collection("RoomData").document(roomID).setData(roomData)
            
            // Reload Room Datas
            self.requestRoomDatas()
        }
    }
    
    func joinRoom(_ roomNumber: String) {
        isValidRoomIDtoJoin(id: roomNumber) { isDone, errString in
            if isDone == false {
                self.joinError = errString
                self.isJoinable = false
            } else {
                self.joinError = " "
                self.isJoinable = true
            }
        }
    }
    
    func deleteRoom(roomID: String, completionHandler: @escaping () -> Void) {
        db.collection("RoomData").document(roomID).delete() { error in
            if let error = error {
                print("Cannot Remove Document: \(error)")
            }
            else {
                self.requestRoomDatas()
            }
        }
    }
    
    func leaveRoom(roomID: String, completionHandler: @escaping () -> Void) {
        db.collection("RoomData").document(roomID).updateData([
            "participants": FieldValue.arrayRemove([userID])
        ]) { error in
            if let error = error {
                print("Cannot Remove Value: \(error)")
            }
            else {
                self.requestRoomDatas()
            }
        }
    }
    
    class func kickUserFromRoom(roomID: String, userName: String) {
        let db = Firestore.firestore()
        let roomDataRef = db.collection("RoomData").document(roomID)
        
        roomDataRef.updateData([
            "participants": FieldValue.arrayRemove([userName]),
            "kickedUsers": FieldValue.arrayUnion([userName])
        ]) { error in
            if let error = error {
                print("Cannot Kick User: \(error)")
            }
        }
    }
    
    class func roomData(with roomID: String, completionHandler: @escaping (RoomData) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("RoomData").document(roomID).getDocument { documentSnapshot, error in
            guard let document = documentSnapshot else {
                return
            }
            
            guard let data = document.data(),
                  let jsonData = try? JSONSerialization.data(withJSONObject: data),
                  let roomData = try? JSONDecoder().decode(RoomData.self, from: jsonData)
            else {
                return
            }
            completionHandler(roomData)
        }
    }
}

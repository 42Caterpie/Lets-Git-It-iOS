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
    
    init () {
        getRoomDatas()
    }
    
    func getRoomDatas() {
        let db = Firestore.firestore()
        let userID = UserDefaults.shared.string(forKey: "userId") ?? Auth.auth().currentUser?.uid ?? "none"
        self.roomDatas = []
        db.collection("RoomData").whereField("participants", arrayContains: userID).getDocuments() { querySnapshot, error in
            if let error = error {
                print (error)
            }
            else {
                let decoder = JSONDecoder()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let jsonData = try? JSONSerialization.data(withJSONObject:data)
                    let roomInfo = try? decoder.decode(RoomData.self, from: jsonData!)
                    guard let roomInfo = roomInfo else { return }
                    self.roomDatas.append(roomInfo)
                    print(roomInfo)
                }
            }
        }
    }
    
    func createRoom(with roomData: RoomData) {
        validRoomIDtoMake() { roomID in
            let db = Firestore.firestore()
            let userID = UserDefaults.shared.string(forKey: "userId") ?? Auth.auth().currentUser?.uid ?? "none"
            let roomData = RoomData(id: roomID,
                                    title: roomData.title,
                                    startDate: roomData.startDate,
                                    goal: roomData.goal,
                                    participants: [userID],
                                    maxParticipants: roomData.maxParticipants).asDictionary!
            db.collection("RoomData").document(roomID).setData(roomData)
            
            // MARK: Reload Room Dats
            
            self.getRoomDatas()
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
}
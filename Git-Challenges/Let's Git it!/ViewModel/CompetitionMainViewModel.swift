//
//  CompetitionMainViewModel.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/21.
//

import Foundation
import Firebase

class CompetitionMainViewModel: ObservableObject {
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
    
    func makeRoom(title: String, goal: Int, maxParticipants: Int, startDate: Date) {
        validRoomIDtoMake() { roomID in
            let db = Firestore.firestore()
            let userID = UserDefaults.shared.string(forKey: "userId") ?? Auth.auth().currentUser?.uid ?? "none"
            let roomData = RoomData(id: roomID,
                                    title: title,
                                    startDate: startDate.toString,
                                    goal: goal,
                                    participants: [userID],
                                    maxParticipants: maxParticipants).asDictionary!
            db.collection("RoomData").document(roomID).setData(roomData)
            self.getRoomDatas()
        }
    }
    func joinRoom(_ roomNumber: String) {
        validRoomIDtoJoin(id: roomNumber) { isDone, errString in
            if isDone == false {
                self.joinError = errString
                self.isJoinable = false
            } else {
                self.joinError = " "
                self.isJoinable = true
            }
        }
    }

    func validRoomIDtoJoin(id: String, completionHandler: @escaping (Bool, String)-> Void) {
        
        // MARK: Check Room ID  with Completion for async
        
        let db = Firestore.firestore()
        let docRef = db.collection("RoomData").document(id)
        let userID = UserDefaults.shared.string(forKey: "userId") ?? Auth.auth().currentUser?.uid ?? "none"
        
        docRef.getDocument { document, err in
            if let document = document, document.exists == true {
                let maxParticipants = document.get("maxParticipants") as! Int
                let currentParticipants = document.get("participants") as! [String]
                let numberParticipants = currentParticipants.count
                let isAlreadyJoined = currentParticipants.contains(userID)
                
                if numberParticipants >= maxParticipants {
                    completionHandler(false, "Room is full.")
                } else if isAlreadyJoined {
                    completionHandler(false, "Already in The Room.")
                } else {
                    docRef.updateData(["participants": FieldValue.arrayUnion([userID])])
                    completionHandler(true, " ")
                }
            } else {
                completionHandler(false, "Room doesn't exist.")
            }
        }
    }
}

func validRoomIDtoMake(completionHandler: @escaping (String)-> Void) {
    let id: String = randomSixDigitCode()
    
    // MARK: Random Room ID Generate with Completion for async
    
    let db = Firestore.firestore()
    let docRef = db.collection("RoomData").document(id)
    docRef.getDocument { document, err in
        if let document = document, document.exists == true {
            validRoomIDtoMake(completionHandler: completionHandler)
        } else {
            completionHandler(id)
        }
    }
}

func randomSixDigitCode() -> String {
    var number = String()
    for _ in 1...6 {
        number += "\(Int.random(in: 1...9))"
    }
    return number
}

extension Encodable {
    /// Object to Dictionary
    /// cf) Dictionary to Object: JSONDecoder().decode(Object.self, from: dictionary)
    var asDictionary: [String: Any]? {
        guard let object = try? JSONEncoder().encode(self),
              let dictinoary = try? JSONSerialization.jsonObject(with: object, options: [])
                as? [String: Any] else { return nil }
        return dictinoary
    }
}

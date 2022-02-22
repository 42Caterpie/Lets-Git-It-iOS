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
    
    init () {
        getRoomDatas()
    }
    
    func getRoomDatas() {
        let db = Firestore.firestore()
        let userID = UserDefaults.shared.string(forKey: "userId") ?? Auth.auth().currentUser?.uid ?? "none"
        
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
}

func makeRoom(_ title: String, _ goal: Int, _ startDate: Date) {
    validRoomID() { roomID in
        let db = Firestore.firestore()
        let userID = UserDefaults.shared.string(forKey: "userId") ?? Auth.auth().currentUser?.uid ?? "none"
        let roomData = RoomData(id: roomID,
                                title: title,
                                startDate: startDate.toString,
                                goal: goal,
                                participants: [userID],
                                maxParticipants: 0).asDictionary!
        db.collection("RoomData").document(roomID).setData(roomData)
    }
}

func validRoomID(completionHandler: @escaping (String)-> Void) {
    let id: String = randomSixDigitCode()
    
    // MARK: Random Room ID Generate with Completion for async
    
    let db = Firestore.firestore()
    let docRef = db.collection("RoomData").document(id)
    docRef.getDocument { document, err in
        if let document = document, document.exists == true {
            validRoomID(completionHandler: completionHandler)
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
              let dictinoary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String: Any] else { return nil }
        return dictinoary
    }
}

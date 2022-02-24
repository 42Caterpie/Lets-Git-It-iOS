//
//  ValidRoomID.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/22.
//

import Foundation
import Firebase

func isValidRoomIDtoJoin(id: String, completionHandler: @escaping (Bool, String)-> Void) {
    
    // MARK: Check Room ID  with Completion for async
    
    if id == "" {
        completionHandler(false, JoinErrorMessage.noRoomID)
        return
    }
    
    let db = Firestore.firestore()
    let docRef = db.collection("RoomData").document(id)
    let userID = UserDefaults.shared.string(forKey: "userId") ?? Auth.auth().currentUser?.uid ?? "none"
    
    docRef.getDocument { document, err in
        if let document = document, document.exists == true {
            let maxParticipants = document.get("maxParticipants") as! Int
            let currentParticipants = document.get("participants") as! [String]
            let kickedUsers = document.get("kickedUsers") as! [String]
            let numberParticipants = currentParticipants.count
            let isAlreadyJoined = currentParticipants.contains(userID)
            
            if kickedUsers.contains(userID) {
                completionHandler(false, JoinErrorMessage.kickedID)
            } else if numberParticipants >= maxParticipants {
                completionHandler(false, JoinErrorMessage.roomIsFull)
            } else if isAlreadyJoined {
                completionHandler(false, JoinErrorMessage.alreadyInRoom)
            } else {
                docRef.updateData(["participants": FieldValue.arrayUnion([userID])])
                completionHandler(true, " ")
            }
        } else {
            completionHandler(false, JoinErrorMessage.cantFindRoom)
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

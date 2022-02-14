//
//  FireStoreService.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/01/25.
//

import Foundation
import Firebase

let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd"
    return dateFormatter
}()

let dateTimeFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
    return dateFormatter
}()

func themeLog() {
    var db: Firestore
    let uid = UserDefaults.shared.string(forKey: "userId") ?? Auth.auth().currentUser?.uid ?? "none"
    
    db = Firestore.firestore()
    
    db.collection("logs").document("Theme").setData(
        [uid : UserDefaults.shared.string(forKey: "ColorTheme")!], merge: true)
}

func goalLog() {
    var db: Firestore
    let uid = UserDefaults.shared.string(forKey: "userId") ?? Auth.auth().currentUser?.uid ?? "none"
    
    db = Firestore.firestore()
    
    db.collection("logs").document("Goal").setData(
        [uid :
            (UserDefaults.shared.string(forKey: "userGoalTitle") ?? "") + " / " + (UserDefaults.shared.string(forKey: "userGoalCount") ?? "")
        ], merge: true)
}

func alarmLog(with time: Date) {
    var db: Firestore
    let uid = UserDefaults.shared.string(forKey: "userId") ?? Auth.auth().currentUser?.uid ?? "none"
    let date: String = dateFormatter.string(from: time)
    db = Firestore.firestore()

    db.collection("logs").document("Alarm").setData(
        [uid: date
        ], merge: true)
}

func userCountLog() {
    var db: Firestore
    let uid = UserDefaults.shared.string(forKey: "userId") ?? Auth.auth().currentUser?.uid ?? "none"
    let date: String = dateFormatter.string(from: Date())
    let dateTime: String = dateTimeFormatter.string(from: Date())
    
    db = Firestore.firestore()
    db.collection("UserDayLogs").document(date).updateData(
        [uid: FieldValue.increment(Int64(1))]) { err in
            if err != nil {
                db.collection("UserDayLogs").document(date).setData([uid : 1])
            }
        }
    
    db.collection("UserTotalLogs").document(uid).updateData(
        ["count": FieldValue.increment(Int64(1))]) { err in
            if err != nil {
                db.collection("UserTotalLogs").document(uid).setData(["count" : 1])
            }
        }

    db.collection("UserTotalLogs").document(uid).updateData(
        [dateTime: FieldValue.increment(Int64(1))]) { err in
            if err != nil {
                db.collection("UserTotalLogs").document(uid).setData([dateTime : 1])
            }
        }
}

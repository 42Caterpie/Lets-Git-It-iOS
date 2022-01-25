//
//  FireStoreService.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/01/25.
//

import Foundation
import Firebase

func ThemeLog() {
    var db: Firestore
    let uid = UserDefaults.standard.string(forKey: "userId") ?? Auth.auth().currentUser?.uid ?? "none"
    
    db = Firestore.firestore()
    
    db.collection("logs").document("Theme").setData(
        [uid : UserDefaults.standard.string(forKey: "ColorTheme")!], merge: true)
}

func GoalLog() {
    var db: Firestore
    let uid = UserDefaults.standard.string(forKey: "userId") ?? Auth.auth().currentUser?.uid ?? "none"
    
    db = Firestore.firestore()
    
    db.collection("logs").document("Goal").setData(
        [uid :
            (UserDefaults.standard.string(forKey: "userGoalTitle") ?? "") + " / " + (UserDefaults.standard.string(forKey: "userGoalCount") ?? "")
        ], merge: true)
}

func AlarmLog() {
    var db: Firestore
    let uid = UserDefaults.standard.string(forKey: "userId") ?? Auth.auth().currentUser?.uid ?? "none"
    
    db = Firestore.firestore()
    // TODO: 알람 시간 추가 필요
    db.collection("logs").document("Alarm").setData(
        [uid :
         "\(UserDefaults.standard.bool(forKey: "hasUserAgreedAlert"))"
        ], merge: true)
}

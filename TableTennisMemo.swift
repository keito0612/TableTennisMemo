//
//  TableTennisMemo.swift
//  TableTennisMemo
//
//  Created by 磯部馨仁 on 2022/08/28.
//

import Foundation
import Firebase
import FirebaseAuth

struct TableTennisMemo: Identifiable {
    let id: String?
    let title: String?
    let startTime:String?
    let endTime:String?
    
    init(doc:Dictionary<String, Any>){
        self.id = doc["id"] as? String ?? ""
        self.title = doc["title"] as? String ?? ""
        self.startTime = doc["startTime"] as? String ?? ""
        self.endTime = doc["endTime"] as? String ??  ""
    }
}

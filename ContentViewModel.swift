//
//  ContentViewModel.swift
//  TableTennisMemo
//
//  Created by 磯部馨仁 on 2022/09/14.
//

import Firebase
import Foundation
import FirebaseFirestore

class ContentViewModel : ObservableObject{
    @Published var TableList =  [TableTennisMemo]()
    let userID = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    
    func getData() async throws  {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let collection = try await db.collection("users").document(uid).collection("TableTennisMemo").document().getDocument()
        guard let snapshot = collection.data() else{return}
        self.TableList = snapshot.map{ doc in TableTennisMemo(doc: [doc.key : doc.value])}
    }
    func delete(id: String) async throws -> Void {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let delete =  try await db.collection(uid).document("TableTennisMemo").collection("memo").document(id).delete()
    }
}


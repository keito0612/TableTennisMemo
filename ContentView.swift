//
//  ContentView.swift
//  TableTennisMemo
//
//  Created by 磯部馨仁 on 2022/08/28.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    //ユーザーID
    let userId = Auth.auth().currentUser!.uid
    
    @ObservedObject private var model = ContentViewModel()
    //エラーメッセージ
    @State private var errorMessage = ""
    // アラート表示フラグ
    @State private var showingAlert = false
    //インジゲーター表示フラグ
    @State var onIndicator = false
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()),
                                    count: 2)
    var body: some View {
        NavigationView{
            ZStack{
                if(onIndicator){
                    //インジゲータ
                    RoundedRectangle(cornerRadius: 10, style: .continuous) .fill(Color.blue)
                        .frame(width:150, height: 150)
                    ProgressView("読み込み中")
                        .foregroundColor(.white)
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        .frame(width:150, height: 150)
                        .background(.black)
                }
        VStack{
            LazyVGrid(columns:columns ){
                ForEach(model.TableList){ item in
                    HStack{
                        
                    }
                }
            }
        }.task {
            do{
                try await model.getData()
            }catch{
               showingAlert = true
            }
        }
        .navigationTitle("リスト")
        .navigationBarTitleDisplayMode(.inline)
        }
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            ContentView()
        }
    }
}

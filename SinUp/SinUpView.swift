//
//  SinUpView.swift
//  TableTennisMemo
//
//  Created by 磯部馨仁 on 2022/08/31.
//

import SwiftUI
import CoreMedia

struct SinUpView: View {
    //メールアドレス
    @State var email :String = ""
    // パスワード
    @State var password :String = ""
    //表示アラートのフラグ
    @State private var showingAlert = false
    //新規登録のフラグ
    @State private var isSinUp = false
    //アラートのテキスト
    @State private var alertText = ""
    //インジゲーター表示フラグ
    @State var onIndicator = true
    //画面遷移フラグ
    @State private var isNextPresented = false
    //チェックフラグ
    @State private var isCheck = false
    
    
    
    
    var body: some View {
            ZStack(alignment: .top) {
                //画面全体の色
                Color.orange.ignoresSafeArea()
                    VStack(alignment: .center) {
                        //画像
                        Image(decorative: "Group 2")
                        .resizable()
                        .frame(width: 100, height:100).background(.orange)
                        
                        ZStack(alignment:.top){
                          VStack{
                              //新規登録ラベル
                              Text("新規登録").font(.largeTitle)
                                  .fontWeight(.black)
                                  .foregroundColor(Color.white)
                              
                              RoundedRectangle(cornerRadius: 50,style:.continuous)
                                  .fill(Color.orange)
                                  .frame(width:370, height: 350)
                                  .overlay(RoundedRectangle(cornerRadius: 16)
                                       .stroke(Color.white, lineWidth: 4))
                              
                          }
                            VStack {
                                //テキストラベル
                                Text("メールアドレス:")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading).padding(EdgeInsets(top: 100, leading: 25, bottom: 0, trailing: 0))
                                //メールアドレス欄
                                emailField("kurume@gmail.com", text: $email)
                                //ラベル
                                Text("パスワード:")
                                    .frame(maxWidth: .infinity, alignment: .leading).foregroundColor(.white)
                                    .padding(.leading,25)
                                //パスワード欄
                                PassWordField("パスワード", text: $password).overlay(
                                    RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                                        .stroke(Color.white, lineWidth: 3.0)
                                        .padding(-8.0)
                                )
                                .frame(width: 330)
                                .padding(EdgeInsets(
                                    top: 0, leading: 40, bottom: 20,
                                    trailing: 40
                                ))
                                
                                CheckBox(isChecked: $isCheck).padding()
                                
                                //登録ボタン
                                Button(action: {
                                    DispatchQueue.global().async {
                                        self.onIndicator = true
                                        DispatchQueue.main.sync {
                                            SinUpModel.SinUp(email: email, password: password, failure: {error in
                                                //ログインが失敗したら
                                                self.onIndicator = false
                                                self.alertText = error
                                                self.showingAlert = true
                                            }, success: {
                                                //ログインが成功したら
                                                self.onIndicator = false
                                                self.alertText = "ログインに成功しました"
                                                self.showingAlert = true
                                                self.isSinUp = true
                                            })
                                        }
                                    }
                                }){ Text("登録").fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .frame(width: 200, height: 50)
                                        .background(Color.orange)
                                        .cornerRadius(24)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.white, lineWidth: 5))
                                }.alert(isPresented: $showingAlert) {
                                    Alert(title: Text(alertText),dismissButton:.default(Text("はい"),action: {
                                        self.isSinUp ? isNextPresented.toggle() : nil
                                    }))
                                    //画面遷移
                                }.fullScreenCover(isPresented: $isNextPresented){
                                    ContentView()
                                }
                            }
                        }
                        Spacer()
                    }
            }
    }
    
    //メールアドレス
    struct emailField: View{
        // メールアドレス
        @Binding private var text: String
        //タイトル
        private var title :String
        
        init(_ title:String, text:Binding<String>){
            self.title = title
            self._text = text
        }
        var body: some View{
            TextField( title ,text: $text).foregroundColor(.white)      .accentColor(Color.white)
                .overlay(RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0)).stroke(Color.white,lineWidth:3.0)
                    .padding(-8.0)
                ).frame(width: 330)
                .padding(EdgeInsets(
                    top: 0, leading: 40, bottom: 40,
                    trailing: 40
                ))
            }
        }
    
    //パスワード欄
    struct PassWordField:View{
        //パスワード
        @Binding  private var text : String
        //タイトル
             private var title :String
        //パスワード表示フラグ
        @State  private  var isSecured: Bool = true
        
        init(_ title:String  ,text: Binding<String> ){
            self.title = title
            self._text = text
        }
        var body: some View{
            HStack{
                Group{
                    if self.isSecured{
                        SecureField(title, text: self.$text)
                    }else{
                        TextField(title, text:$text)
                    }
                }.foregroundColor(.white)
                //パスワード隠しボタン
                Button(action: {
                    isSecured.toggle()
                }) {
                    Image(systemName: self.isSecured ? "eye.slash" : "eye")
                        .accentColor(.white)
                }.padding(.leading,10)
            }
        }
    }
    //チェックボックス
    struct CheckBox:View{
        @Binding private var  isChecked: Bool
        
           init(isChecked:Binding<Bool>){
            self._isChecked = isChecked
        }
        
        var body: some View{
            HStack(){
                Button(action: toggle) {
                    if(isChecked) {
                        Image(systemName: "checkmark.square.fill")
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: "square").foregroundColor(.white)
                    }
                }
                Text("規約にサインをお願いします").foregroundColor(.white)
            }
        }
        // タップ時の状態の切り替え
           func toggle(){
               isChecked = !isChecked
               UIImpactFeedbackGenerator(style: .medium)
               .impactOccurred()
           }
    }
    
    
    
    struct SinUpView_Previews: PreviewProvider {
        static var previews: some View {
            SinUpView()
        }
    }
}

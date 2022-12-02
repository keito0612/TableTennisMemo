//
//  LoginView.swift
//  TableTennisMemo
//
//  Created by 磯部馨仁 on 2022/08/28.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    //ユーザネーム
    @State  private var email: String = ""
    //パスワード
    @State  private var password: String = ""
    //アラート表示フラグ
    @State private var showingAlert = false
    //ログインフラグ
    @State private var isLogin = false
    //アラートテキスト
    @State private var alertText = ""
    //インジゲーター表示フラグ
    @State var onIndicator = false
    //画面遷移フラグ
    @State private var isNextPresented = false
    
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.gray.ignoresSafeArea()
                VStack(alignment: .center){
                    ZStack(alignment: .top) {
                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.white)
                            .frame(width:370, height: 450).shadow(radius: 5)
                        ZStack {
                            if onIndicator {
                               ReadIndicator()
                            }
                        }
                        //ログインラベル
                        VStack {
                            Text("ログイン").font(.largeTitle).fontWeight(.black)
                                .padding()
                            //メールアドレスラベル
                            Text("メールアドレス:")
                                .frame(maxWidth: .infinity, alignment: .leading).padding(EdgeInsets(top: 10, leading: 25, bottom: 0, trailing: 0))
                            //メールアドレス欄
                            TextField( "メールアドレス" ,text: $email).overlay(RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0)).stroke(Color.black,lineWidth:1.0)
                                .padding(-8.0)
                            ).frame(width: 330)
                                .padding(EdgeInsets(
                                    top: 0, leading: 40, bottom: 40,
                                    trailing: 40
                                ))
                            //ラベル
                            Text("パスワード:")
                                .frame(maxWidth: .infinity, alignment: .leading).padding(.leading,25)
                            //パスワード欄
                            PassWordField("パスワード", text: $password).overlay(
                                RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                                    .stroke(Color.black, lineWidth: 1.0)
                                    .padding(-8.0)
                            )
                            .frame(width: 330)
                            .padding(EdgeInsets(
                                top: 0, leading: 40, bottom: 30,
                                trailing: 40
                            ))
                            //登録ボタン
                            Button(action: {
                                onIndicator = true
                                DispatchQueue.main.async {
                                    LoginModel.login(email: email, password: password, failure: {error in
                                        self.onIndicator = false
                                        self.alertText = error
                                        self.showingAlert = true
                                    } ,success:{
                                        
                                        self.onIndicator = false
                                        self.alertText = "ログインが完了しました"
                                        self.showingAlert = true
                                    })
                              }
                            }){Text("登録").fontWeight(.bold)}.alert(isPresented: $showingAlert) {
                                Alert(title: Text(alertText),dismissButton:.default(Text("了解"),action: {
                                    self.isLogin ? isNextPresented.toggle() : nil
                                }))
                               //画面遷移
                            }.fullScreenCover(isPresented: $isNextPresented){
                                ContentView()
                            }
                                .frame(width: 200, height: 50)
                                .background(Color.red)
                                .cornerRadius(24)
                            HStack(){
                                Button(action:{
                                }){
                                    Text("パスワード忘れた方").fontWeight(.bold)
                                }
                                Spacer().frame(width: 80)
                            NavigationLink(destination: SinUpView()) {
                                Text("新規登録").fontWeight(.bold)
                            }.padding()
                            }
                            Spacer()
                        }
                    }
                }
            }
        }.accentColor(Color.white)
    }
}


    struct PassWordField:View{
        @Binding  private var text : String
        private var title :String
        @State  private  var isSecured: Bool = true
        init(_ title:String  ,text: Binding<String> ){
            self.title = title
            self._text = text
        }
        var body: some View{
            HStack{
                if(isSecured){
                  TextField(title, text:$text)
                }else{
                   SecureField(title, text:$text)
                }
                Button(action: {
                    isSecured.toggle()
                }) {
                    Image(systemName: self.isSecured ? "eye.slash" : "eye")
                        .accentColor(.gray)
                }.padding(.leading,10)
            }
        }
    }

struct LoginButton:View {
    private let email:String
    private let password:String
    @State var alertText :String
    @Binding  private var onIndicator:Bool
    @Binding  private var showingAlert: Bool
    @Binding  private var isNextPresented: Bool
    @Binding private var isLogin: Bool
    init(email:String,password:String, alertText:String,onIndicator:Binding<Bool>,
         showingAlert: Binding<Bool>,isNextPresented:Binding<Bool>,isLogin:Binding<Bool>){
        self.email = email
        self.password = password
        self.alertText = alertText
        self._onIndicator = onIndicator
        self._showingAlert = showingAlert
        self._isNextPresented = isNextPresented
        self._isLogin = isLogin
    }
    
    var body: some View{
        //登録ボタン
        Button(action: {
            onIndicator = true
            DispatchQueue.main.async {
                LoginModel.login(email: email, password: password, failure: {error in
                    self.onIndicator = false
                    self.alertText = error
                    self.showingAlert = true
                } ,success:{
                    self.onIndicator = false
                    self.alertText = "ログインが完了しました"
                    self.showingAlert = true
                })
            }
        }){
            Text("登録").fontWeight(.bold)}.alert(isPresented: $showingAlert) {
                Alert(title: Text(self.alertText),dismissButton:.default(Text("了解"),action: {
                    self.isLogin ? isNextPresented.toggle() : nil
                }))
            }
    }
    
    
    
    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView()
        }
    }
}

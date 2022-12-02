//
//  LoginModel.swift
//  TableTennisMemo
//
//  Created by 磯部馨仁 on 2022/09/04.
//

import Foundation
import FirebaseAuth
import Firebase
 
class LoginModel{
    static func login(email: String, password: String,failure:@escaping (String) -> Void, success:@escaping () -> Void ){
        Auth.auth().signIn(withEmail:email, password: password){(result,error) in
            DispatchQueue.global().async {
            if let error = error {
                if let errCode = AuthErrorCode.Code(rawValue: error._code) {
                    switch errCode {
                    case .invalidEmail:
                        failure("メールアドレスの形式が違います。")
                    case .emailAlreadyInUse:
                        failure("このメールアドレスはすでに使われています。")
                    case .weakPassword:
                        failure("パスワードは6文字以上で入力してください。")
                    case .networkError:
                        failure("通信エラーです。")
                    case .wrongPassword:
                        failure("メールアドレス、もしくはパスワードが違います。")
                    default:
                        failure("エラーが起きました。\nしばらくしてから再度お試しください。")
                    }
                }
            }else{
                success()
            }
          }
        }
    }
}



//
//  SinUpModel.swift
//  TableTennisMemo
//
//  Created by 磯部馨仁 on 2022/08/31.
//

import Foundation
import Firebase
import FirebaseAuth

class SinUpModel{
    
    deinit {
        print("メモリが開放されたよ")
    }
    
    static func SinUp(email: String, password: String,failure:@escaping (String) -> Void, success:@escaping () -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
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

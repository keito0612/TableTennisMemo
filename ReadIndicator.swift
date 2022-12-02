//
//  ReadIndicator.swift
//  TableTennisMemo
//
//  Created by 磯部馨仁 on 2022/12/02.
//

import Foundation
import SwiftUI

struct ReadIndicator:View {
    var body: some View{
        //インジゲータ
        RoundedRectangle(cornerRadius: 10, style: .continuous) .fill(Color.blue)
            .frame(width:150, height: 150)
        ProgressView("読み込み中")
            .foregroundColor(.white)
            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
            .frame(width:150, height: 150)
            .background(.black)
    }
}

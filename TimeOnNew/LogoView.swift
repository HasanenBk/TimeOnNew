//
//  LogoView.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-09.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        
        ZStack {
            (LinearGradient(gradient: Gradient (colors: [((/*@START_MENU_TOKEN@*/Color(red: 0.232, green: 0.231, blue: 0.244)/*@END_MENU_TOKEN@*/)), (Color.blue)]),startPoint: .topLeading, endPoint: .bottomTrailing))
                .ignoresSafeArea()
            
            VStack {
                
                Image("Screenshot2").resizable()
                    .frame(width: 230, height: 130)
                    .padding()
                
                // loading sprinner
                ProgressView()
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .progressViewStyle(CircularProgressViewStyle(tint:(Color(hue: 0.517, saturation: 0.347, brightness: 0.913))))
                    .scaleEffect (2)
                
                
                Text("Version. 1.2.1")
                    .foregroundColor(Color(hue: 1.0, saturation: 0.014, brightness: 0.94, opacity: 0.745))
                    .padding(.top, 120)
                
                
            }
            
        }
           
    }
}

struct BekSidaView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}

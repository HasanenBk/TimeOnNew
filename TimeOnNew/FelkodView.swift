//
//  FelkodView.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-05.
//

import SwiftUI

struct FelkodView: View {
    var body: some View {
        ZStack {
            (LinearGradient(gradient: Gradient (colors: [((/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.226, green: 0.259, blue: 0.315)/*@END_MENU_TOKEN@*/)), (Color.blue)]),startPoint: .topLeading, endPoint: .bottomTrailing))
                .ignoresSafeArea(edges: .top)
            VStack {
                Text("⚠️")
                    .font(.largeTitle)
                Text("Fel kod!")
                    .font(.title3)
                .foregroundColor(Color.white)
                
                Spacer().frame(height: 200)
            
                Link("Kontakta support", destination: URL(string: "https://forms.gle/qbW258c2gAx1QBjb6")!)
                    .padding()
                    .background(.black)
                    .cornerRadius(10)
                    
            }
                
            
        }
    }
}

struct FelkodView_Previews: PreviewProvider {
    static var previews: some View {
        FelkodView()
    }
}

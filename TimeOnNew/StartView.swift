//
//  StartView.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-05.
//

import SwiftUI

struct StartView: View {
   
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.darkGray
        
        // TabBar color
      //  UITabBar.appearance().backgroundColor = UIColor(Color(hue: 0.548, saturation: 1.5, brightness: 1.0))
    }
        @State var tabViewSelection = 0
            
        @State var singleTabWidth = UIScreen.main.bounds.width / 4
    

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            TabView(selection: $tabViewSelection) {
                
                HomeView()
                    .tabItem(){
                        
                        Image(systemName: "calendar.badge.clock")
                        Text("Schema")
                        
                    }.tag(0)
                
                MeddelandeView()//.badge(1)
                    .tabItem(){
                        Image(systemName: "envelope.fill")
                        Text("Meddelanden")
                    }.tag(1)
                
                AllaPassView()
                    .tabItem(){
                        Image(systemName: "checklist")
                        Text("Mina pass")
                        
                    }.tag(2)
                
                ProfilView()
                    .tabItem(){
                        Image(systemName: "person.crop.circle")
                        Text("Profil")
                        
                    }.tag(3)
            }
            Rectangle()
                .foregroundColor(Color.blue)
                .offset(x: singleTabWidth * CGFloat(tabViewSelection))
                .frame(width: singleTabWidth, height: 2.7)
              
            
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}

//
//  AllaPassView.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-05.
//

import SwiftUI

struct AllaPassView: View {
    
    /*
    // för att bytta Navigationbar text färg
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.init((/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.009, green: 0.476, blue: 0.999)/*@END_MENU_TOKEN@*/))]
    }
     */
     
    
    // för att har det valt från början
    @State var minaPass = true
    
    
    var body: some View {
       
        ZStack {
            VStack {
                if(minaPass == true){ Text("MINA PASS")
                        .font(.title3)
                        .foregroundColor(Color(red: 1.0, green: 1.0, blue: 1.0))
                        .accessibilityAddTraits(.isHeader)
                } else {
                    
                    Text("ANSVARIG")
                        .font(.title3)
                        .foregroundColor(Color(red: 1.0, green: 1.0, blue: 1.0))
                        .accessibilityAddTraits(.isHeader)
                }
            
          
                VStack {
                
                Picker(selection: $minaPass, label: Text("")) {
                    
                    Text("Mina pass")
                        .tag(true)
                    
                    Text("Ansvarig")
                        .tag(false)
                    
                }
                
                .pickerStyle(SegmentedPickerStyle())
                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: -0.236, green: 0.585, blue: 0.858)/*@END_MENU_TOKEN@*/)
                .shadow(radius: 10)
                .cornerRadius(10)
         //       .frame(height: 50)
                .scaleEffect(CGSize(width: 1.0, height: 1.2))
                 
                
                if(!minaPass){
                    
                    AnsvarigkodView()
                } else {
                    
                    MinaPassView()
                }
                
           }
            .padding()
        }
      
     }.background(LinearGradient(gradient: Gradient (colors: [((/*@START_MENU_TOKEN@*/Color(red: 0.232, green: 0.231, blue: 0.244)/*@END_MENU_TOKEN@*/)), (Color.blue)]),startPoint: .topLeading, endPoint: .bottomTrailing)
        .ignoresSafeArea(edges: .top))
      
            
       
    }
}

struct AllaPassView_Previews: PreviewProvider {
    static var previews: some View {
        AllaPassView()
    }
}

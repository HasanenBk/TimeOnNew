//
//  ContentView.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-05.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @StateObject var inloggadmaker = RegistreringCode()
    
    @State var loggan = false // för att visa logo vyn
    
    var body: some View {
        
        ZStack {
            NavigationStack {
                
                // om vi inte inloggda visa inloggingsida
                if (inloggadmaker.inloggad == false){
                    
                    InloggningView()
                    
                } else {
                    
                    StartView()
                }
                
            }
            if(loggan == true){
                 LogoView()
                
            }
        }
        // för att visa och försvinna
        .onAppear(){
            
            // visa loggan
            loggan = true
            
            // lyssnare som kollar om vi är inloggda
            var handle = Auth.auth().addStateDidChangeListener { auth, user in
                
                // om vi inte har änvendare (nil)
                if (Auth.auth().currentUser == nil){
                    inloggadmaker.inloggad = false
                } else {
                    
                    inloggadmaker.inloggad = true
                }
                loggan = false
                loggan = true
                //timer som tar bort loggan vyn efter 1.0 second
               DispatchQueue.main.asyncAfter(deadline:.now()+1.5){
               loggan = false
                }
            }
            
        }
        
    }
        
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  InloggningCode.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-05.
//

import Foundation
import Firebase
            // en typ av lyssnare som kollar värdet av saker vi väljer genom att ha (@Published) innan
            // och skicka värdet om det ändras
class InloggningCode : ObservableObject {
    
    @Published var felMeddelande = false
    
    // för att visa logo vyn mellan det logga in
    @Published var isloading = false
    
    @Published var raderatKontoMeddelande = false

    func loggain(inloggningEpost : String, inloggningPass : String) {
        
            isloading = true // visa logo vyn
        
        Auth.auth().signIn(withEmail: inloggningEpost, password: inloggningPass) { authResult, error in
          
            self.isloading = false // dolj logo vyn
            
            // om vi har fel variable felMeddelande blir true
            // och det visar inget alert
            
            if (error != nil){
                self.felMeddelande = true   //(self i den observableObject)
                //Misslyckad inloggning
            }
        }
    }
}

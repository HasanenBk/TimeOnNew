//
//  RegistreringView.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-05.
//

import SwiftUI
import Firebase

struct RegistreringView: View {
    
    
    @State var registreringPass = ""
    
    @StateObject var registreringmaker = RegistreringCode()
    
    // Definiera referens som spara och hämta data från firebase
    var ref: DatabaseReference! = Database.database().reference()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
       
        ZStack {
            
            (LinearGradient(gradient: Gradient (colors: [((/*@START_MENU_TOKEN@*/Color(red: 0.232, green: 0.231, blue: 0.244)/*@END_MENU_TOKEN@*/)), (Color.blue)]),startPoint: .topLeading, endPoint: .bottomTrailing))
                .ignoresSafeArea()
            
           
                
                ScrollView {
                    
                    
                VStack {
                    Image("Screenshot2").resizable()
                        .frame(width: 210, height: 120)
                        .shadow(radius: 10)
                    
                    
                    HStack {
                        Text("Skapa ditt Time On konto")
                            .foregroundColor(Color(red: 0.291, green: 0.746, blue: 0.797))
                            .multilineTextAlignment(.center)
                            .padding([.leading, .trailing], 34)
                        
                        Spacer()
                    }
                    
                    
                    TextField("Namn", text: $registreringmaker.registreringNamn)
                    
                        .keyboardType(.emailAddress)
                        .padding(.all)
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.291, green: 0.746, blue: 0.801)/*@END_MENU_TOKEN@*/)
                        .cornerRadius(40)
                        .padding([.leading, .trailing])
                    
                    
                    TextField("Efternamn", text: $registreringmaker.registreringEfternamn)
                    
                        .keyboardType(.emailAddress)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.291, green: 0.746, blue: 0.801)/*@END_MENU_TOKEN@*/)
                        .cornerRadius(40)
                        .padding([.leading, .trailing])
                    
                    
                    TextField("Mobilnummer", text: $registreringmaker.registreringnummer)
                    
                        .keyboardType(.emailAddress)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.291, green: 0.746, blue: 0.801)/*@END_MENU_TOKEN@*/)
                        .cornerRadius(40)
                        .padding([.leading, .trailing])
                    
                    TextField("E-post", text: $registreringmaker.registreringEpost)
                    
                        .keyboardType(.emailAddress)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.291, green: 0.746, blue: 0.801)/*@END_MENU_TOKEN@*/)
                        .cornerRadius(40)
                        .padding([.leading, .trailing])
                    
                    SecureField("Lösenord", text: $registreringPass)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.291, green: 0.746, blue: 0.801)/*@END_MENU_TOKEN@*/)
                        .cornerRadius(40)
                        .padding([.leading, .trailing])
                    
                    TextField("Registreringskod", text: $registreringmaker.registcode)
                    
                        .keyboardType(.emailAddress)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.291, green: 0.746, blue: 0.801)/*@END_MENU_TOKEN@*/)
                        .cornerRadius(40)
                        .padding([.leading, .trailing])
                    
                    Button(action: {
                        
                        // Starta med det nya StateObject variable
                        // anroppa func som vi har skapat i RegistreringCode File (registrera, och spara registrering info på firebase)
                        registreringmaker.registrering(anvNamn: registreringmaker.registreringNamn, anvEfternamn: registreringmaker.registreringEfternamn, anvMobilnummer: registreringmaker.registreringnummer, anvEpost: registreringmaker.registreringEpost, anvPass: registreringPass, regkoden: registreringmaker.registcode)
                        
                        
                        
                    }, label: {
                        
                        Text("Skapa konto")
                            .foregroundColor(Color(red: 0.232, green: 0.231, blue: 0.244))
                            .padding(.all)
                            .padding([.leading, .trailing], 70)
                            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: -0.236, green: 0.585, blue: 0.858)/*@END_MENU_TOKEN@*/)
                            .cornerRadius(40)
                            .shadow(radius: 10)
                        
                        
                    })
                }.onTapGesture {
                    self.dismissKevboard()
            }
                
            }
            // visa logo vyn mellan det loggar in
            if(registreringmaker.isloading) {
                LogoView()
            }
            
    }
        .alert("Fel E-post", isPresented: $registreringmaker.felMeddelande) {
            Button("Okej"){ }
        }
        
        .alert("Du har inte fyllt alla textfält", isPresented: $registreringmaker.felMeddelande2) {
            Button("Okej"){ }
        }
        
        .alert("Fel registreringkod", isPresented: $registreringmaker.felMeddelande3) {
            Button("Okej"){ }
        }
        
        .alert("✅ \nRegistrering lyckades!", isPresented: $registreringmaker.reglyckats) {
            Button("Okej"){ dismiss() }
        }
        
        
    }
    }
struct RegistreringView_Previews: PreviewProvider {
    static var previews: some View {
        RegistreringView()
    }
}

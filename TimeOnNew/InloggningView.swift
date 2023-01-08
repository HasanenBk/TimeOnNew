//
//  InloggningView.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-05.
//

import SwiftUI

struct InloggningView: View {
    
    @AppStorage("epost") var inloggningEpost: String = ""
   // @State var inloggningEpost = ""
    
    @AppStorage("pass") var inloggningPass: String = ""
   // @State var inloggningPass = ""
    
    // kommunicera med vår class och kolla om där är ändring
   @StateObject var loginmaker = InloggningCode()
    
    var body: some View {
       
        NavigationStack {
            ZStack {
                (LinearGradient(gradient: Gradient (colors: [((/*@START_MENU_TOKEN@*/Color(red: 0.232, green: 0.231, blue: 0.244)/*@END_MENU_TOKEN@*/)), (Color.blue)]),startPoint: .topLeading, endPoint: .bottomTrailing))
                    .ignoresSafeArea()
                
              
                
                
                
                VStack {
                    Image("Screenshot2").resizable()
                        .frame(width: 230, height: 130)
                        .shadow(radius: 10)

                    
                    TextField("E-post", text: $inloggningEpost)
                    
                        .keyboardType(.emailAddress)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.291, green: 0.746, blue: 0.801)/*@END_MENU_TOKEN@*/)
                        .cornerRadius(40)
                        .padding([.leading, .trailing])
                    
                    SecureField("Lösenord", text: $inloggningPass)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.291, green: 0.746, blue: 0.801)/*@END_MENU_TOKEN@*/)
                        .cornerRadius(40)
                        .padding(.top,10)
                        .padding([.leading, .trailing])
                    
                    Button(action: {
                        // Starta med det nya StateObject variable
                        // anroppa func som vi har skapat i InloggningFile
                        loginmaker.loggain(inloggningEpost: inloggningEpost, inloggningPass: inloggningPass)
                        
                    }, label: {
                        
                        Text("Logga in")
                            .padding([.leading, .trailing], 80)
                            .foregroundColor(Color(red: 0.232, green: 0.231, blue: 0.244))
                            .padding(.all)
                            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: -0.236, green: 0.585, blue: 0.858)/*@END_MENU_TOKEN@*/)
                            .cornerRadius(40)
                            .padding(.top,10)

                    })
                    
                    NavigationLink(destination: {
                        RegistreringView()
                    }, label: {
                        Text("eller skapa ett konto här!")
                            .underline()
                            .foregroundColor(Color(hue: 0.517, saturation: 0.347, brightness: 0.913))
                            .padding(.vertical)
                    })
                    .padding(.vertical)
                   
                    
                }
                // visa logo vyn mellan det loggar in
                if(loginmaker.isloading) {
                    withAnimation{ LogoView()
                    }
                }
            }.onTapGesture {
                self.dismissKevboard()
            }
            
        }// alert som visar felMeddelande när man matar in fel
        .alert("Fel e-post eller lösenord", isPresented: $loginmaker.felMeddelande) {
            Button("Okej"){ }
        }
        .alert("Ditt konto är raderat!", isPresented: $loginmaker.raderatKontoMeddelande) {
            Button("Okej"){ }
        }
       
        
    }
    
   
}

struct InloggningView_Previews: PreviewProvider {
    static var previews: some View {
        InloggningView()
    }
}

//
//  ProfilView.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-05.
//

import SwiftUI
import Firebase
import FirebaseStorage
import AVFoundation

struct ProfilView: View {
    
    @State private var isPresentingConfirm: Bool = false
    
    @StateObject var profilmaker = RegistreringCode()
    
    @StateObject var profilmaker2 = InloggningCode()
    
    var ref: DatabaseReference! = Database.database().reference()
    
    @State var anvNamn = ""
    @State var anvEfternamn = ""
    @State var anvMobilnummer = ""
    @State var anvEpost = ""
    
    @State var raderaKontofelMeddelande = false
    
    var body: some View {
        
        
        
        ZStack {
            
            LinearGradient(gradient: Gradient (colors: [((/*@START_MENU_TOKEN@*/Color(red: 0.232, green: 0.231, blue: 0.244)/*@END_MENU_TOKEN@*/)), (Color.blue)]),startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea(edges: .top)
            
            ScrollView {
                
                //Circle()
                //   .scale(1.6)
                //  .foregroundColor(.white.opacity(0.06))
                
                
                VStack {
                    
                    Spacer()
                    Image("Screenshot2").resizable()
                        .padding(.top)
                        .frame(width: 210, height: 130)
                        .shadow(radius: 10)
                    
                    
                    
                    VStack {
                        
                        HStack {
                            Text("Namn")
                                .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.939, opacity: 0.77))
                            //          .padding(.leading)
                            Spacer()
                        }
                        
                        TextField("", text: $anvNamn)
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            .background(Color(hue: 0.548, saturation: 0.254, brightness: 1.0, opacity: 0.413))
                            .cornerRadius(15)
                            .disabled(true)
                            .padding(.horizontal)
                        
                        
                        HStack {
                            Text("Mobilnummer")
                                .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.939, opacity: 0.77))
                            //   .padding(.leading)
                            Spacer()
                        }
                        
                        TextField("", text: $anvMobilnummer)
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            .background(Color(hue: 0.548, saturation: 0.254, brightness: 1.0, opacity: 0.413))
                            .cornerRadius(15)
                            .disabled(true)
                            .padding(.horizontal)
                        
                        
                        HStack {
                            Text("E-post")
                                .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.939, opacity: 0.77))
                            //      .padding(.leading)
                            Spacer()
                        }
                        
                        TextField("", text: $anvEpost)
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            .background(Color(hue: 0.548, saturation: 0.254, brightness: 1.0, opacity: 0.413))
                            .cornerRadius(15)
                            .disabled(true)
                            .padding(.bottom)
                            .padding(.horizontal)
                    }.padding([.top, .leading, .trailing])
                    
                    
                    Button(action: {
                        let user = Auth.auth()
                        do {
                            try user.signOut()
                        } catch let signOutError as NSError {
                            print("Error signing out: %@", signOutError)
                        }
                        
                    }, label: {
                        
                        Text("Logga ut")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.232, green: 0.231, blue: 0.244))
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            .padding([.leading, .trailing], 70)
                            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: -0.236, green: 0.585, blue: 0.858)/*@END_MENU_TOKEN@*/)
                            .cornerRadius(40)
                            .shadow(radius: 10)
                        
                    })
                    
                    Button("Radera konto", role: .destructive ) {
                        
                          isPresentingConfirm = true
                        
                        }.confirmationDialog("Are you sure?",
                         isPresented: $isPresentingConfirm) {
                         Button("Ja, Radera", role: .destructive) {
                             deleteUserInfo()
                             deleteAccount()
                          }
                        } message: {
                            Text("Är du säker att du vill radera ditt konto?")
                          }
                         .font(.subheadline)
                        .foregroundColor(Color(red: 0.232, green: 0.231, blue: 0.244))
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .padding([.leading, .trailing], 55)
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: -0.236, green: 0.585, blue: 0.858)/*@END_MENU_TOKEN@*/)
                        .cornerRadius(40)
                        .shadow(radius: 10)
                
                }
                
            }
            
            
        }  // visa den hämtade bild när man starta appen
        .onAppear(){
            
            profilmaker.getInfo() {
                anvNamn = profilmaker.usersAppInfo.fullname
                
                anvMobilnummer = profilmaker.usersAppInfo.nummer
                anvEpost = profilmaker.usersAppInfo.epost
            }
            
        }.alert("⚠️ \nLogga in igen för att radera ditt konto.", isPresented: $raderaKontofelMeddelande) {
            Button("Okej"){ }
        }
        
    }
    func deleteAccount(){
        
        let user = Auth.auth().currentUser!
        
        user.delete { error in
          if let error = error {
              print(error)
              raderaKontofelMeddelande = true
              
          } else {
              profilmaker2.raderatKontoMeddelande = true
          }
        }
     
    }
    
    func deleteUserInfo() {
        
        guard let user = Auth.auth().currentUser
        else {
            return
        }
        let currentuserId = user.uid
        
        self.ref.child("users").child(currentuserId).getData(completion:  { error, snapshot in
            
            //     for _ in snapshot!.children{
            
            let currentuserInfo = snapshot!.value as! [String : Any]
            
            let tempcurrentuser = Appuser()
            tempcurrentuser.theId = currentuserId
            tempcurrentuser.orgkod = currentuserInfo["orgcode"] as! String
        
            ref.child("Organisation").child(tempcurrentuser.orgkod).child("users").child("userinfo").child(currentuserId).removeValue()
        
        ref.child("Organisation").child(tempcurrentuser.orgkod).child("users").child("user schema").child(currentuserId).removeValue()
        
        ref.child("Organisation").child(tempcurrentuser.orgkod).child("users").child("user totaltime").child(currentuserId).removeValue()
    }
  )}
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView()
        
    }
}

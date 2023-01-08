//
//  AnsvarigkodView.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-05.
//

import SwiftUI
import Firebase



struct AnsvarigkodView: View {
   
    // to hide keyboard after action
    enum Field: Hashable {
            case myField
        }
    
    @FocusState private var focusedField: Field?
    
    @AppStorage("kod") var ansvarigcode: String = ""
   
    var ref: DatabaseReference! = Database.database().reference()
 
    @State var kod = ""
    @State var felkod = false
    
    var body: some View {
            
            ZStack {
        
                Color.clear
                    .ignoresSafeArea(edges: .top)
                
                VStack {
                    
                    Text("Ange ansvarigskod för att lägga till eller ta bort pass")
                        .font(.title2)
                        .foregroundColor(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 1.0, green: 1.0, blue: 1.0)/*@END_MENU_TOKEN@*/)
                        .padding(.all)
                  
                    SecureField("Ansvarigskod", text: $ansvarigcode)
                        .focused($focusedField, equals: .myField)
                        .keyboardType(.emailAddress)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .background(Color(hue: 0.548, saturation: 0.254, brightness: 1.0, opacity: 0.413))
                        .cornerRadius(20)
                        .padding([.leading, .trailing], 24)
                    
                    NavigationLink(destination: {
                        if(ansvarigcode == kod){
                            AnsvarigView()
                        
                        } else {
                            FelkodView()

                        }
                    }, label: {
                        Text("Gå vidare")
                            .foregroundColor(Color(red: 0.232, green:0.231, blue: 0.244))
                            .padding()
                            .padding([.leading, .trailing], 80)
                            .background(Color(red: -0.236, green: 0.585, blue: 0.858))
                            .cornerRadius(40)
                            .shadow(radius: 10)
                        // to give navigationlink an action
                    }).simultaneousGesture(TapGesture().onEnded{
                        // dissmiss keyboard
                        focusedField = nil
                    }).padding(.top)
                   
                }
            }.onTapGesture {
                self.dismissKevboard()
            }
            .onAppear(){

                loadAnsvarigKod()
               
            }
    }
    func loadAnsvarigKod() {
        
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
        
            ref.child("Organisation").child(tempcurrentuser.orgkod).child("code ansvarig").getData(completion: { error, snapshot in
            
            for child in snapshot!.children {
                
                let kodSnapshot = child as! DataSnapshot
                                
                let thekod = kodSnapshot.key
                
                kod = thekod
                
               
            
            }
                
        })
      })
    }
}

struct ChangePassView_Previews: PreviewProvider {
    static var previews: some View {
        AnsvarigkodView()
    }
    
}

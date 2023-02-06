//
//  AdminView.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-09.
//

import SwiftUI
import Firebase

struct AdminView: View {
    
    var ref: DatabaseReference! = Database.database().reference()
    
    @State var users = [Timeinfo]()
    
    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea(edges: .top)
            
            VStack {
                List{
                    ForEach(users, id: \.name){ info in
                        
                        VStack{
                            HStack {
                                Spacer()
                                Text(info.month)
                                    .foregroundColor(Color.blue)
                            }
                            HStack{
                                
                                Text(info.name)
                                    .foregroundColor(Color.white)
                                Spacer()
                                Text(info.total)
                                    .foregroundColor(Color.white)
                                Text("Timmar")
                                    .foregroundColor(Color.white)
                            }
                            
                        }
                    }
                    .listRowBackground(Color.black)
                }
            }
        }.background(LinearGradient(gradient: Gradient (colors: [((/*@START_MENU_TOKEN@*/Color(red: 0.232, green: 0.231, blue: 0.244)/*@END_MENU_TOKEN@*/)), (Color.blue)]),startPoint: .topLeading, endPoint: .bottomTrailing))
            .scrollContentBackground(Visibility.hidden)
            .onAppear(){
                loadUsersTime()
        }
    }
    
    func loadUsersTime() {
        
        
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
        
            ref.child("Organisation").child(tempcurrentuser.orgkod).child("users worktime").getData(completion: { error, snapshot in
            
            for child in snapshot!.children {
                
                let childSnapshot = child as! DataSnapshot
                let theuserInfo = childSnapshot.value as! [String : Any]
                let theusers = childSnapshot.key
                
                let tempPass = Timeinfo()
                tempPass.id = currentuserId
               tempPass.month = theuserInfo["datum"] as! String
               tempPass.total = theuserInfo["Total timmar"] as! String
               tempPass.name = theuserInfo["name"] as! String
                
              print(theusers)
               users.append(tempPass)
              
            }
        })
    }
  )}
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}

class adminvy {
   var allNames  = ""
}

//
//  MinaPassView.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-05.
//

import SwiftUI
import Firebase
import Foundation

struct MinaPassView: View {
    
    // Definiera referens som spara och hämta data från firebase
    var ref: DatabaseReference! = Database.database().reference()
    @StateObject var minapass = passCode()
        
    @State var manad = Date.now.formatted(.dateTime.month(.wide).year(.twoDigits))
    
    @State var userWorktimeinfo = Timeinfo()
    
    @State var totaltimmar : Double = 0
    
    @State var showmonths = false
    
    // reload sheet after add or delete
  //  @State var homeload : () -> Void
    
    var body: some View {
      
        ZStack {
        VStack {
            
            ZStack {
                
                RoundedRectangle (cornerRadius: 15)
                    .fill(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.107, green: 0.102, blue: 0.102)/*@END_MENU_TOKEN@*/)
                    .frame(height: 45)
                
                HStack {
                    
                    NavigationLink(destination: {
                      AllmounthsView()
                    }, label: {
                        Text(manad)
                            .frame(width: 120, height: 35)
                            .foregroundColor(Color.black)
                            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: -0.236, green: 0.585, blue: 0.858)/*@END_MENU_TOKEN@*/)
                            .cornerRadius(10)
                        
                        
                    })
                    
                    
                    Spacer()
                    Text("Total timmar:")
                        .foregroundColor(Color.blue)
                    
                    // visa första 2 nummer efter decimal
                    Text(String(format: "%.2f", totaltimmar))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.blue)
                }
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
            }
              
            List(minapass.allPasslist, id: \.allPassIds) { allpass in
                    HStack {
                        
                        Text(allpass.allPassDate)
                            .font(.title3)
                            .foregroundColor(Color.white)
              
                      
                        Spacer()
                        
                        Text(allpass.allPassStart + " -")
                            .foregroundColor(Color.white)
                        Text(allpass.allPassEnd)
                            .foregroundColor(Color.white)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.blue)
                        
                    }.listRowBackground(Color.black)
                    
                }
            .background(Color(red: 0.107, green: 0.102, blue: 0.102))
            .scrollContentBackground(Visibility.hidden)
            .cornerRadius(25)

                    
                    
                .onAppear() {
                    print("MINA PASS APPEAR")
                    minapass.getmypass()
              
                    totaltime()
                   
                 }
            
        }
    }
    }
        
    func totaltime() {
        
        totaltimmar = 0.0
        
        // hämta användarens Id om det inte är nil
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
        
            self.ref.child("Organisation").child(tempcurrentuser.orgkod).child("users").child("worktime").queryOrdered(byChild: "userid").queryEqual(toValue: currentuserId).observeSingleEvent(of: .value, with: { snapshot in
            
            
            for child in snapshot.children {
                
                let passSnapshot = child as! DataSnapshot
                
                let thepass = passSnapshot.value as! [String : Any]
                
                let thepassids = passSnapshot.key
                
                let temptime = Timeinfo()
                temptime.passId = thepassids
                temptime.datum = thepass["datum"] as! String
                temptime.name = thepass["name"] as! String
                temptime.passtime = thepass["pass tid"] as! Double
                temptime.month = thepass["mounth"] as! String
                
                    userWorktimeinfo = temptime
               
                if (manad == userWorktimeinfo.month){
                    totaltimmar += userWorktimeinfo.passtime
                }
  //              print(123)
   //             print(userWorktimeinfo.mounth)
                
                savetotaltime(registreringkod: tempcurrentuser.orgkod)
        
                }
              
            }
        
        )}
        )}
    
    func savetotaltime(registreringkod : String) {
        // spara användarens tider under admin-firebase
            var worktimeinfo = [String : Any]()
          
        worktimeinfo["datum"] = minapass.month
        worktimeinfo["Total timmar"] = (String(format: "%.2f", totaltimmar))

        ref.child("Organisation").child(registreringkod).child("users worktime").child(userWorktimeinfo.name).child (minapass.month).setValue(worktimeinfo)
        
        
        // kolla användarens Id
        let userId = Auth.auth().currentUser!.uid
        
        ref.child("Organisation").child(registreringkod).child("users").child("user totaltime").child(userId).child (minapass.month).setValue(worktimeinfo)
    }
}

struct MinaPassView_Previews: PreviewProvider {
    static var previews: some View {
        MinaPassView()
    }
}

class Timeinfo {
  var passId = ""
  var datum = ""
  var name = ""
  var passtime = 0.0
  var month = ""
  var total = ""
  var id = ""
}

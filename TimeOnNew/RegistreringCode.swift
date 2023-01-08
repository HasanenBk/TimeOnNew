//
//  RegistreringCode.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-05.
//

import Foundation
import Firebase

class RegistreringCode : ObservableObject {
    
    @Published var allusers = [Appuser]()
    
    @Published var usersAppInfo = Appuser()
        
    @Published var registreringNamn = ""
    
    @Published var registreringEfternamn = ""
    
    @Published var registreringnummer = ""
    
    @Published var registreringEpost = ""
    
    @Published var registcode = ""
    
    @Published var felMeddelande = false
    
    @Published var felMeddelande2 = false
   
    @Published var felMeddelande3 = false
    
    @Published var reglyckats = false

    @Published var isloading = false
    
    @Published var inloggad = true
     
   // var theId = ""
    
    var ref: DatabaseReference! = Database.database().reference()

    
    func registrering(anvNamn : String, anvEfternamn : String, anvMobilnummer : String, anvEpost : String, anvPass : String, regkoden : String){
        
        if (anvNamn == ""){
            felMeddelande2 = true
            return
        }
        if (anvEfternamn == ""){
            felMeddelande2 = true
            return
        }
        if (anvMobilnummer == ""){
            felMeddelande2 = true
            return
        }
        

        // test
        if (regkoden == theOrgcode.mkkcode || regkoden == theOrgcode.rancode || regkoden == theOrgcode.tbgcode){
 
            
            isloading = true
                
regist(anvEpost: anvEpost, anvPass: anvPass, regkoden: regkoden)
        } else {
            felMeddelande3 = true
        }
    }
    
    func regist(anvEpost : String, anvPass : String, regkoden : String){
        
        Auth.auth().createUser(withEmail: anvEpost, password: anvPass) { [self] authResult, error in
            
           
            self.isloading = false
            reglyckats = true
            
            
            if (error != nil){
                self.felMeddelande = true
            } else {
              
                // ok reg
                // spara registrering info till firebase database
                
                let userId = authResult!.user.uid
                
                var userinfo = [String : Any]()
                userinfo["namn"] = registreringNamn
                userinfo["efternamn"] = registreringEfternamn
                userinfo["Mobilnummer"] = registreringnummer
                userinfo["Epost"] = registreringEpost
                userinfo["orgcode"] = regkoden
                
                ref.child("Organisation").child(regkoden).child("users").child("userinfo").child(userId).setValue(userinfo)
                
                ref.child("users").child(userId).setValue(userinfo)
                
                
            }
        }
    }
         // telling the func to do after completion
    func getInfo(completion: @escaping () -> ()) {
        
        // hämta användarens Id om det inte är nil
        guard let user = Auth.auth().currentUser
        else {
            return
        }
        let currentuserId = user.uid
    
        self.ref.child("users").child(currentuserId).getData(completion:  { error, snapshot in
    //    self.ref.child("Organisation").child(registreringkod.code.rawValue).child("users").child("userinfo").child(currentuserId).getData(completion:  { error, snapshot in
            
            
            guard error == nil else {
                print("Data hämtning misslyckades")
                return
            }
           for child in snapshot!.children {
               _ = child as! DataSnapshot
            let userInfo = snapshot!.value as! [String : Any]
            let key = snapshot!.key
                print(key)
                
        // anroppa variablar som finns i RegistreringCode() filen och ge de  värdet som vi har på firebase
                let tempuserInfo = Appuser()
                tempuserInfo.theId = currentuserId
            tempuserInfo.namn = userInfo["namn"] as? String ?? ""
                tempuserInfo.efternamn = userInfo["efternamn"] as! String
                tempuserInfo.nummer = userInfo["Mobilnummer"] as! String
                tempuserInfo.epost = userInfo["Epost"] as! String
                tempuserInfo.fullname = tempuserInfo.namn + " " + tempuserInfo.efternamn
                
            if(error != nil){
                // fel hämtning
                print("FEL USER INFO GET")
                
            } else {
            print("OK USER GET")
            self.usersAppInfo = tempuserInfo
            completion()
            }
                                
       }
                    
    })
        
  }
    
    
    func loadUsers(completion: @escaping () -> ()) {
        
        allusers = []
        
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
                
            
            self.ref.child("Organisation").child(tempcurrentuser.orgkod).child("users").child("userinfo").queryOrdered(byChild: "namn").observeSingleEvent(of: .value, with: { snapshot in
            
            for child in snapshot.children {
    
                let userSnapshot = child as! DataSnapshot
                let userInfo = userSnapshot.value as! [String : Any]
                let userId = userSnapshot.key
                
        // anroppa variablar som finns i RegistreringCode() filen och ge de  värdet som vi har på firebase
                let tempuserInfo = Appuser()
                tempuserInfo.namn = userInfo["namn"] as! String
                tempuserInfo.efternamn = userInfo["efternamn"] as! String
                tempuserInfo.fullname = tempuserInfo.namn + " " + tempuserInfo.efternamn
                tempuserInfo.theId = userId
                
                self.allusers.append(tempuserInfo)
               
            }
            
            completion()
            
        })
      })
    }
    
}


class Appuser {
    var namn = ""
    var efternamn = ""
    var fullname = ""
    var nummer = ""
    var epost = ""
    var theId = ""
    var orgkod = ""

}

struct theOrgcode {
    static var mkkcode = "M123kzz"
    static var rancode = "N234lxx"
    static var tbgcode = "N345tvv"
    
}

/*
        registreringkod.code = .failure

      for club in Klubb.allCases {
           if regkoden == club.rawValue {
               registreringkod.code = club
           }
       }
      if registreringkod.code != .failure { code }

enum Klubb: String, RawRepresentable, CaseIterable {
    case M123kzz
    case N234lxx
    case failure
}

struct registreringkod {
    static var code: Klubb = .M123kzz
    
}
*/

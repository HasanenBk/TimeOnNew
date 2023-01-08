//
//  passCode.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-05.
//

import Foundation
import Firebase


class passCode : ObservableObject {
    
    // Definiera referens som spara och hämta data från firebase
    var ref: DatabaseReference! = Database.database().reference()
    
     var allPassName = ""
     var allPassStart = ""
     var allPassEnd = ""
     var allPassDate = ""
     var allPassIds = ""
     var passAnsvarig = ""
     var passAnsvarignamn = ""
     var passUserid = ""
    
   @Published var startTime = Date.now
   @Published var endTime = Date.now
   @Published var workingDate = Date.now.formatted(.dateTime.day().month()) // for view
   @Published var month = Date.now.formatted(.dateTime.month(.wide).year(.twoDigits)) // for count hours

    var start : Double = 0
    var slut : Double = 0
    var totaltimmar : (Double) = 0
    
    @Published var totalmanadtimmar = 0
    
    @Published var allPasslist = [passCode]()
  
    // för att visa loading vyn när det laddar
    @Published var isloading = false
    
    @Published var felinmatning = false
    
    @Published var ingetnamn = false
    
    // Spara data på firebase
    func addnewpass(addname : String, userid: String, starttime : Date, endtime : Date, ansvarig : String)  {
        
        if(addname == ""){ // tom text
            self.ingetnamn = true
            return
        }
        
        if(addname == " Ange namn"){ // tom text
            self.ingetnamn = true
            return
        }
        if(endtime <= starttime){
            self.felinmatning = true
            return
        }
        
        // Convert start time to String
        let startformatter = DateFormatter()
        startformatter.timeStyle = .short
        // Convert end time to String
        let slutformatter = DateFormatter()
        slutformatter.timeStyle = .short
        
        let dateformatter = DateFormatter()
        dateformatter.timeStyle = .short
        
        let antalsek = Double(endtime.timeIntervalSince1970 - starttime.timeIntervalSince1970)
        let passtime = antalsek / 3600
       
        
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
            
            var passinfo = [String : Any]()
            passinfo["name"] = addname
            passinfo["start"] = (startformatter.string(from: starttime))
            passinfo["slut"] = (slutformatter.string(from: endtime))
            passinfo["pass tid"] = passtime
            passinfo["datum"] = self.workingDate
            passinfo["mounth"] = self.month
            passinfo["userid"] = userid
            passinfo["ansvarig"] = currentuserId
            passinfo["ansvarig namn"] = ansvarig
            
            // Spara data på firebase (namn, starttid, sluttid)
            // .childByAutoId() om vi vill skapa nytt id
            self.ref.child("Organisation").child(tempcurrentuser.orgkod).child("users").child("worktime").childByAutoId().setValue(passinfo)
            
        })
    }
    
    // Hämta data från firebase
    func getthepass() {
        
        allPasslist = []
        
        // visa loading vyn
        self.isloading = true
        
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
            
            self.ref.child("Organisation").child(tempcurrentuser.orgkod).child("users").child("worktime").getData(completion: { error, snapshot in
                
                // filtera för att hämta current ansvarig pass
                
                //   self.ref.child("Org MKK").child("user").child("worktime").queryOrdered(byChild: "ansvarig").queryEqual(toValue: currentuserId).observeSingleEvent(of: .value, with: { snapshot in
                
                guard error == nil else {
                    print("Data hämtning misslyckades")
                    return
                }
                
                for child in snapshot!.children {
                    
                    let passSnapshot = child as! DataSnapshot
                    
                    let thepass = passSnapshot.value as! [String : Any]
                    
                    let thepassids = passSnapshot.key
                    
                    // anroppa variablar som finns i passcode() filen och ge de värdet som vi har på firebase
                    let tempPass = passCode()
                    tempPass.allPassIds = thepassids
                    tempPass.allPassName = thepass["name"] as! String
                    tempPass.allPassStart = thepass["start"] as! String
                    tempPass.allPassEnd = thepass["slut"] as! String
                    tempPass.allPassDate = thepass["datum"] as! String
                    tempPass.passAnsvarig = thepass["ansvarig"] as! String
                    tempPass.passUserid = thepass["userid"] as! String
                    tempPass.passAnsvarignamn = thepass["ansvarig namn"] as! String
                    
                    self.allPasslist.append(tempPass)
                    print(thepassids)
                }
                
                // dölj loading vyn
                self.isloading = false
                
            })
        })
    }
    
    
    func getmypass() {
        
        allPasslist = []
        
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
            
            // visa loading vyn
            self.isloading = true
            
            self.ref.child("Organisation").child(tempcurrentuser.orgkod).child("users").child("worktime").queryOrdered(byChild: "userid").queryEqual(toValue: currentuserId).observeSingleEvent(of: .value, with: { snapshot in
                
                for child in snapshot.children {
                    
                    let passSnapshot = child as! DataSnapshot
                    
                    let thepass = passSnapshot.value as! [String : Any]
                    
                    let thepassids = passSnapshot.key
                    
                    // anroppa variablar som finns i passcode() filen och ge de värdet som vi har på firebase
                    let tempPass = passCode()
                    tempPass.allPassIds = thepassids
                    tempPass.allPassName = thepass["name"] as! String
                    tempPass.allPassStart = thepass["start"] as! String
                    tempPass.allPassEnd = thepass["slut"] as! String
                    tempPass.allPassDate = thepass["datum"] as! String
                    tempPass.passAnsvarig = thepass["ansvarig"] as! String
                    tempPass.passUserid = thepass["userid"] as! String
                    
                    self.allPasslist.append(tempPass)
                    print("Det är" + thepassids)
                }
                
                // dölj loading vyn
                self.isloading = false
                
            })
        })
    }
    
    
    
       // delete key som vi har sin index i deletepass func
    func deletefromfirebase(passidtodelete : String){
        
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
        
        print("LETS DELETE KEY: " + passidtodelete)
        
            self.ref.child("Organisation").child(tempcurrentuser.orgkod).child("users").child("worktime").child(passidtodelete).removeValue()
        
    }
  )}
}

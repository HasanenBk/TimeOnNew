//
//  SchemaCode.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-05.
//

import Foundation
import Firebase

class SchemaCode : ObservableObject{
    
    @Published var allSchemainfo = [Schemainfo?]()
   // @Published var userSchemakomment = Schemainfo()
    
    // för att visa loading vyn när det laddar
    @Published var isloading = false
    
    @Published var felhamtning = false
    
    var ref: DatabaseReference! = Database.database().reference()
    
    func loadschema() {
        // Tömma listan först
        allSchemainfo.removeAll()
        
        allSchemainfo.append(nil)
        allSchemainfo.append(nil)
        allSchemainfo.append(nil)
        allSchemainfo.append(nil)
        allSchemainfo.append(nil)
        allSchemainfo.append(nil)
        allSchemainfo.append(nil)
        
        
        guard let user = Auth.auth().currentUser
        else {
            return
        }
        let currentuserId = user.uid
        
        self.ref.child("users").child(currentuserId).getData(completion:  { error, snapshot in
            
            //     for _ in snapshot!.children{
            
            guard error == nil else {
                print("Data hämtning misslyckades")
                self.felhamtning = true
                return
            }
            
            let currentuserInfo = snapshot!.value as! [String : Any]
            
            let tempcurrentuser = Appuser()
            tempcurrentuser.theId = currentuserId
            tempcurrentuser.orgkod = currentuserInfo["orgcode"] as! String
            
            self.isloading = true
            
            self.ref.child("Organisation").child(tempcurrentuser.orgkod).child("users").child("user schema").child(currentuserId).getData(completion:  { error, snapshot in
                
                guard error == nil else {
                    print("Data hämtning misslyckades")
                    self.felhamtning = true
                    return
                }
                
                for child in snapshot!.children {
                    
                    let schemaSnapshot = child as! DataSnapshot
                    
                    let userSchemainfo = schemaSnapshot.value as! [String : Any]
                    
                    let tempschema = Schemainfo()
                    tempschema.starttime = userSchemainfo["start"] as! String
                    tempschema.endtime = userSchemainfo["slut"] as! String
                    tempschema.comment = userSchemainfo["kommentar"] as! String
                    
                    // Om key som sparas på firebase(dagen) == String i arrayn
                    if(schemaSnapshot.key == "Måndag")
                    {
                        self.allSchemainfo[0] = tempschema
                    }
                    if(schemaSnapshot.key == "Tisdag")
                    {
                        self.allSchemainfo[1] = tempschema
                    }
                    if(schemaSnapshot.key == "Onsdag")
                    {
                        self.allSchemainfo[2] = tempschema
                    }
                    if(schemaSnapshot.key == "Torsdag")
                    {
                        self.allSchemainfo[3] = tempschema
                    }
                    if(schemaSnapshot.key == "Fredag")
                    {
                        self.allSchemainfo[4] = tempschema
                    }
                    if(schemaSnapshot.key == "Lördag")
                    {
                        self.allSchemainfo[5] = tempschema
                    }
                    if(schemaSnapshot.key == "Söndag")
                    {
                        self.allSchemainfo[6] = tempschema
                    }
                    
                    
                }
                self.isloading = false
                print("SCHEMA")
                print(self.allSchemainfo)
            })
        }
                                                             
        )}
}

class Schemainfo {
    
    var starttime = ""
    var endtime  = ""
    var comment = ""
    
}

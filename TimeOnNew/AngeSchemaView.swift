//
//  AngeSchemaView.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-05.
//

import SwiftUI
import Firebase


// Spara datepicker på Appstorage
import Foundation
extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}

struct AngeSchemaView: View {
    
    @State var dag = ""
    
    @AppStorage("savedDate") var startTime: Date = Date()
    @AppStorage("save") var endTime: Date = Date()
  //  @State var startTime = Date.now
   // @State var endTime = Date.now
    
    @State var currentDay : String
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var schemamaker = SchemaCode()
    
    @State var currentschema : Schemainfo?
    
    @State var kommentar = ""
    // reload homeview efter add eller delete
    @State var homeload : () -> Void
    
    // Definiera referens som spara och hämta data från firebase
    var ref: DatabaseReference! = Database.database().reference()
    
    var body: some View {
         
        ZStack {
            
           (Color(red: 0.107, green: 0.102, blue: 0.102))
                .ignoresSafeArea(edges: .top)
            
            VStack{
                HStack{
                  
                    Spacer()
                    Button(action: {
                        
                        tabort()
                        homeload()
                        dismiss()
                        
                    }, label: {
                        Image(systemName: "trash")
                            .foregroundColor(Color.red)
                            Text("Ta bort")
                            .foregroundColor(Color.blue)
                            .padding(.trailing)

                    })
                }
               

                    Text(currentDay)
                    .font(.title2)
                        .foregroundColor(.blue)
                        
           
                // Time picker
                Form {
                    
                    Section (header: Text ("")) {
                        DatePicker("Start tid:", selection: $startTime, displayedComponents:
                                . hourAndMinute)
                       
                    }
                    
                    Section (header: Text ("")) {
                        DatePicker("Slut tid:", selection: $endTime, displayedComponents:
                                . hourAndMinute)
                        
                    }
                    
                }
             
                .frame(height: 230)
                .background(LinearGradient(gradient: Gradient (colors: [((Color(red: 0.111, green: 0.447, blue: 0.884))),(Color(red: 0.111, green: 0.447, blue: 0.884))]),startPoint: .topLeading, endPoint: .bottomTrailing))
                .scrollContentBackground(Visibility.hidden)
                .cornerRadius(35)
                .padding([.leading, .trailing])
                
                
                HStack{
                    Text("Kommentar:")
                        .foregroundColor(Color.blue)
                        .padding(.leading)
                    Spacer()
                }
                
                TextField("Skriv här", text: $kommentar)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.black)
                    .background(Color(hue: 0.598, saturation: 0.0, brightness: 0.945, opacity: 0.93))
                    .cornerRadius(20)
                    .padding([.leading, .trailing])
                
                
                Button(action: {
                    
                    sparaschema()
                    
                    homeload()
                    
                    dismiss()
                   
                   
                }, label: {
                    
                    Text("Spara")
                        .padding([.leading, .trailing], 50)
                        .padding()
                        .foregroundColor(Color(red: 0.232, green: 0.231, blue: 0.244))
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: -0.236, green: 0.585, blue: 0.858)/*@END_MENU_TOKEN@*/)
                        .cornerRadius(40)
                        .shadow(radius: 10)
                        .padding(.bottom)
                })
                
            }.onAppear() {
                
                schemamaker.loadschema()
                
                guard let komment = currentschema?.comment
                else {
                    return
                }
                kommentar = komment
              //  startTime = currentschema?.starttime
            }
        } .onTapGesture {
            self.dismissKevboard()
        }
    }
    func sparaschema() {
        
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
            
            // Convert start time to String
            let startformatter = DateFormatter()
            startformatter.timeStyle = .short
            // Convert end time to String
            let slutformatter = DateFormatter()
            slutformatter.timeStyle = .short
            
            // hämta användarens Id
      //      let userId = Auth.auth().currentUser!.uid
            
            var schemainfo = [String : Any]()
            
            schemainfo["start"] = (startformatter.string(from: startTime))
            schemainfo["slut"] = (slutformatter.string(from: endTime))
            schemainfo["kommentar"] = kommentar
            
            
            ref.child("Organisation").child(tempcurrentuser.orgkod).child("users").child("user schema").child(currentuserId).child(currentDay).setValue(schemainfo)
            
            schemamaker.loadschema()
        }
        )}
    
    func tabort(){
        
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
        
            ref.child("Organisation").child(tempcurrentuser.orgkod).child("users").child("user schema").child(currentuserId).child(currentDay).removeValue()
        })
    }
}
struct AngeSchemaView_Previews: PreviewProvider {
    static var previews: some View {
        AngeSchemaView(currentDay: "Måndag", kommentar: "", homeload: {})
    }
}

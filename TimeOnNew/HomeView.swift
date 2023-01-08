//
//  HomeView.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-05.
//

import SwiftUI
import Firebase
import MessageUI

struct HomeView: View {
    
    let veckodagar = ["Måndag","Tisdag","Onsdag","Torsdag", "Fredag","Lördag","Söndag"]
    
  //  @State var komment = ""
    
    @State var datum = Date.now.formatted(.dateTime.weekday(.wide).day().month())
        
    @StateObject var schemamaker = SchemaCode()
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                ZStack {
                    
                    RoundedRectangle (cornerRadius: 15)
                    
                        .fill(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.107, green: 0.102, blue: 0.102)/*@END_MENU_TOKEN@*/)
                        .frame(height: 50)
                    
                    
                    HStack {
                        
                        Text("Today")
                            .font(.title2)
                            .foregroundColor(Color.blue)
                        Spacer()
                        Text(datum)
                            .font(.title2)
                            .foregroundColor(Color.blue)
                    }
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    
                }
                .padding([.leading, .trailing])
    /*
                Button(action: {
                    if MFMailComposeViewController.canSendMail() {
                        let mail = MFMailComposeViewController()
                        mail.mailComposeDelegate = self
                        mail.setSubject("Some subject")
                        mail.setToRecipients(["someemail@example.com"])
                        mail.setMessageBody("Some body", isHTML:false)
                        present(mail, animated: true)
                    } else {
                    // show failure alert
                    }
                    
                }) {
                    Text("EMAIL")
                }
     */
                NavigationStack {
                    ZStack {
                        Color.black
                        VStack {
                            if(schemamaker.allSchemainfo.count > 0)
                            {
                                
                                ForEach(Array(veckodagar.enumerated()), id: \.element) { idx, day in
                                    
                                    NavigationLink(destination: {
                                        AngeSchemaView(currentDay: veckodagar[idx], currentschema: schemamaker.allSchemainfo[idx], homeload: {
                                            schemamaker.loadschema()
                                        })
                                    }, label: {
                                        
                                        
                                        HStack {
                                            Text(veckodagar[idx])
                                                .foregroundColor(Color.blue)
                                                .padding([.top, .leading, .bottom])
                                            
                                            Spacer()
                                            
                                            if(schemamaker.allSchemainfo[idx] != nil)
                                            {
                                               
                                                //Image(systemName: "clock.fill")
                                                    //.foregroundColor(Color(red: 0.215, green: 0.552, blue: 0.591))
                                                    
                                                    
                                                Text(schemamaker.allSchemainfo[idx]!.starttime)
                                                    .foregroundColor(Color(hue: 0.0, saturation: 0.017, brightness: 0.863))
                                                
                                                Text("-")
                                                    .foregroundColor(Color.blue)
                                                
                                                
                                                Text(schemamaker.allSchemainfo[idx]!.endtime)
                                                    .foregroundColor(Color(hue: 0.0, saturation: 0.017, brightness: 0.863))
                                                    .padding(.trailing)
                                            
                                        }
                                            
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(Color.blue)
                                                .padding(.trailing)
                                        }
                                        
                                        
                                    }
                                    )}
                            }
                        }
                        if(schemamaker.isloading == true){
                            loadSchemaView()
                        }
                    }.padding().background(Color(red: 0.107, green: 0.102, blue: 0.102))
                }
                .scrollContentBackground(Visibility.hidden)
                .cornerRadius(15)
                .padding([.leading, .trailing, .bottom])
             //   .frame(height: 600)
                
                
                Spacer()
                
            }.background(LinearGradient(gradient: Gradient (colors: [((/*@START_MENU_TOKEN@*/Color(red: 0.232, green: 0.231, blue: 0.244)/*@END_MENU_TOKEN@*/)), (Color.blue)]),startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea(edges: .top))
            
           
        }.alert("Data hämtning misslyckades \n Kolla din internetanslutning", isPresented: $schemamaker.felhamtning) {
            Button("Okej"){ }
        }
        .onAppear(){
            
            schemamaker.loadschema()
           
        }
       
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

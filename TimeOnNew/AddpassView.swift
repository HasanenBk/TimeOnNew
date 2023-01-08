//
//  AddpassView.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-05.
//

import SwiftUI

struct AddpassView: View {
    
   // @State var addName = ""
    
    // kommunicera med vår class och kolla om där är ändring
    @StateObject var passmaker = passCode()

    
    @StateObject var passmakerReg = RegistreringCode()
        
    @Environment(\.dismiss) var dismiss
    
    @State var selectedName = ""
    
    @State var anvNamn = ""
    
    @State var anvEfternamn = ""
    
    var body: some View {
        
        ZStack {
            
            (LinearGradient(gradient: Gradient (colors: [((/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.226, green: 0.259, blue: 0.315)/*@END_MENU_TOKEN@*/)), (Color.blue)]),startPoint: .topLeading, endPoint: .bottomTrailing))
            
                .ignoresSafeArea(edges: .top)
                
        VStack {
            
            
            Text("Ange namn och tid för nytt pass:")
            
                .font(.title2)
                .foregroundColor(Color.white)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .frame(height: 100.0)
            
            
            /*   TextField("Namn", text: $selectedName)
             
             .keyboardType(.emailAddress)
             .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
             .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 1.0, green: 1.0, blue: 1.0)/*@END_MENU_TOKEN@*/)
             .cornerRadius(20)
             .padding([.leading, .trailing], 24)
             .foregroundColor(Color.white)
             .disabled(true) */
            
            
            Picker(selection: $selectedName,label: Text ("Namn")) {
                ForEach(passmakerReg.allusers, id: \.fullname){ allusers in
                    
                    Text(allusers.namn)+Text(" \(allusers.efternamn)")
                    
                }
                
            }
            .frame(width: 300, height: 55)
            .background(Color(red: 1.0, green: 1.0, blue: 1.0))
            .cornerRadius(20)
            .padding(.bottom)
         
            // Time picker
            Form {
                Section (header: Text ("")) {
                    DatePicker("Start tid:", selection: $passmaker.startTime, displayedComponents:
                            . hourAndMinute)
                }
                
                Section (header: Text ("")) {
                    DatePicker("Slut tid:", selection: $passmaker.endTime, displayedComponents:
                            . hourAndMinute)
                }
                
                
            }.padding()
                .frame(height: 260)
                .cornerRadius(40)
                .background(LinearGradient(gradient: Gradient (colors: [((Color(red: 0.111, green: 0.447, blue: 0.884))),(Color(red: 0.111, green: 0.447, blue: 0.884))]),startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(64)
                .shadow(radius: 15)
                .scrollContentBackground(Visibility.hidden)
            
            
            Button(action: {
                /*
                 
                 passmaker.totaltime(starttime: passmaker.startTime, endtime: passmaker.endTime)
                 
                 */
                
                var selectUser = Appuser()
                for checkuser in passmakerReg.allusers {
                    if(selectedName == (checkuser.namn + " " + checkuser.efternamn))
                    {
                        selectUser = checkuser
                        
                    }
                    
                }
                
                passmaker.addnewpass(addname: selectedName, userid: selectUser.theId, starttime: passmaker.startTime, endtime: passmaker.endTime, ansvarig: anvNamn)
                
                // anroppa func getthepass
                passmaker.getthepass()
                
                dismiss()
                
            }, label: {
                
                Text("Lägg till")
                    .font(.title2)
                    .foregroundColor(Color(red: 0.232, green: 0.231, blue: 0.244))
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .padding([.leading, .trailing], 100)
                    .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: -0.236, green: 0.585, blue: 0.858)/*@END_MENU_TOKEN@*/)
                    .cornerRadius(40)
                    .shadow(radius: 15)
                
            })
            .padding(.top)
            Spacer()
        }.padding()
        }
        .background(Color.clear)//(LinearGradient(gradient: Gradient (colors: [((/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.226, green: 0.259, blue: 0.315)/*@END_MENU_TOKEN@*/)), (Color.blue)]),startPoint: .topLeading, endPoint: .bottomTrailing))
        
        // alert som visar felMeddelande när man matar in fel
        .alert("❌ \n \nFel tid! Passet ska vara under samma dag.", isPresented: $passmaker.felinmatning) {
            Button("Okej"){ }
        }
        
        .alert("⚠️ \n \nVänligen ange namn och tid.", isPresented: $passmaker.ingetnamn) {
            Button("Okej"){ }
        }
            
        .onAppear() {
            passmakerReg.loadUsers(){}
                //selectedName = passmakerReg.allusers[0].namn + " " + passmakerReg.allusers[0].efternamn
            
            
            passmakerReg.getInfo() {
                anvNamn = passmakerReg.usersAppInfo.namn
                anvEfternamn = passmakerReg.usersAppInfo.efternamn
            }
        }
        
    }
}

struct AddpassView_Previews: PreviewProvider {
    static var previews: some View {
        AddpassView()
    }
}

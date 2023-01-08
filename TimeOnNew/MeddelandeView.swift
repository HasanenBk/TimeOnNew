//
//  MeddelandeView.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-05.
//

import SwiftUI
import Firebase

//code to close the kevboard
extension View {
    
    func dismissKevboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct MeddelandeView: View {
    
    @State var chatText = ""
    
    @State var introtext = "  Message"
    
    @State var allmessages = [Appchat]()
    
    @StateObject var passAnsvarmaker = RegistreringCode()
    
    @State var anvNamn = ""
    @State var anvEfternamn = ""
    
    // Definiera referens som spara och hämta data från firebase
    var ref: DatabaseReference! = Database.database().reference()
    
    var body: some View {
        
        ZStack {
            
            (LinearGradient(gradient: Gradient (colors: [((Color(red: 0.232, green: 0.231, blue: 0.244))), (Color.blue)]),startPoint: .topLeading, endPoint: .bottomTrailing))
                .ignoresSafeArea(edges: .top)
            
            VStack{
                // reader first
                 ScrollViewReader { proxy in
                    ScrollView {
                        
                        
                        ForEach (allmessages, id: \.theMessageId) {message in
                            VStack {
                                
                                if(message.theSendername == (anvNamn + " " + anvEfternamn)){
                                    
                                    HStack{
                                        Spacer()
                                        Text(message.theSendername)
                                            .foregroundColor(Color(hue: 1.0, saturation: 0.018, brightness: 0.684, opacity: 0.747))
                                            .padding(.bottom,-5)
                                            .shadow(radius: 10)
                                    }
                                    
                                    
                                    HStack {
                                        Spacer()
                                        VStack{
                                            
                                            Text(message.theText)
                                            
                                            
                                        }.padding()
                                            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(hue: 0.399, saturation: 0.637, brightness: 0.801)/*@END_MENU_TOKEN@*/)
                                            .cornerRadius(40)
                                            .shadow(radius: 10)
                                        
                                    }.padding(.bottom, 10)
                                } else {
                                    
                                    HStack{
                                        
                                        Text(message.theSendername)
                                            .foregroundColor(Color(hue: 1.0, saturation: 0.018, brightness: 0.684, opacity: 0.747))
                                            .padding(.bottom,-5)
                                            .shadow(radius: 10)
                                        
                                        Spacer()
                                    }
                                    
                                    
                                    HStack {
                                        VStack{
                                            
                                            Text(message.theText)
                                            
                                            
                                        }.padding()
                                            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(hue: 0.518, saturation: 0.042, brightness: 0.754)/*@END_MENU_TOKEN@*/)
                                            .cornerRadius(40)
                                            .shadow(radius: 10)
                                        Spacer()
                                        
                                    }.padding(.bottom, 10)
                                    
                                }
                                
                                
                            }
                        } // räkna messages
                        .onChange(of: allmessages.count) { _ in
                            
                            if(allmessages.count > 0)
                            {
                                proxy.scrollTo(allmessages.last!.theMessageId, anchor: .bottom)
                            }
                        }
                        HStack {
                            Spacer()
                            
                        }
                         
                        .onAppear(perform:){
                            //proxy.scrollTo(allmessages.last?.theMessageId, anchor: .bottom)
                            
                            loadmessage()
                            passAnsvarmaker.getInfo() {
                                anvNamn = passAnsvarmaker.usersAppInfo.namn
                                anvEfternamn = passAnsvarmaker.usersAppInfo.efternamn
                            }
                            
                        }
                    }
                    
                }.padding([.top, .leading, .trailing])
                
                    .onTapGesture {
                        self.dismissKevboard()
                    }
                // knapp för keyboard
                /*      .toolbar{
                 ToolbarItemGroup(placement: .keyboard) {
                 Button(action: {
                 self.dismissKevboard()
                 }, label: {
                 Image(systemName: "chevron.down")
                 })
                 
                  }
                 }  */
                
                Spacer()
                HStack{
                    
                    Image(systemName: "message")
                        .padding(.leading)
                    
                    ZStack {
                        
                        /* TextField("Message", text: $chatText)
                         .keyboardType(.asciiCapable)
                         .cornerRadius(25)
                         .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                         .background(Color(hue: 0.555, saturation: 0.634, brightness: 0.843))
                         */
                        
                        TextEditor(text: $chatText)
                            .frame(height: 40)
                            .cornerRadius(20)
                            .colorMultiply(Color(hue: 0.555, saturation: 0.063, brightness: 0.972))
                        
                        if(chatText == ""){
                            HStack {
                                Text(introtext)
                                    .font(.footnote)
                                    .foregroundColor(Color(hue: 1.0, saturation: 0.019, brightness: 0.731))
                                Spacer()
                            }
                        }
                        
                    }
                    HStack {
                        
                        Button(action: {
                            
                            withAnimation {
                                sendmessage(chattext: chatText)
                                
                                loadmessage()
                                
                            }
                        }, label: {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(Color(red: 0.133, green: 0.428, blue: 0.823))
                                .fontWeight(.bold)
                                .padding(.trailing)
                            
                        })
                    }
                    
                    
                }.background(Color(hue: 0.555, saturation: 0.063, brightness: 0.972))
                    .cornerRadius(40)
                    .padding([.leading, .bottom, .trailing])
            }
        }
        
    }
    
    func sendmessage(chattext : String) {
        
        if(chatText == ""){
            return
        }
        
        
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
            
        
        var chatinfo = [String : Any]()
        
        chatinfo["username"] = anvNamn + " " + anvEfternamn
        chatinfo["text"] = chatText
        
            ref.child("Organisation").child(tempcurrentuser.orgkod).child("users").child("user messages").childByAutoId().setValue(chatinfo)
        
        self.chatText = ""
            
        })
    }
    
    func loadmessage() {
        
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
        
        allmessages = []
        
            self.ref.child("Organisation").child(tempcurrentuser.orgkod).child("users").child("user messages").getData(completion:  { error, snapshot in
            
            guard error == nil else {
                print("Data hämtning misslyckades")
                return
            }
            for child in snapshot!.children {
                
                let chatSnapshot = child as! DataSnapshot
                let chatInfo = chatSnapshot.value as! [String : Any]
                let messageId = chatSnapshot.key
                
                let tempchatinfo = Appchat()
                tempchatinfo.theText = chatInfo["text"] as! String
                tempchatinfo.theSendername = chatInfo["username"] as! String
                tempchatinfo.theMessageId = messageId
                
                allmessages.append(tempchatinfo)
                
                print(allmessages)
            }
            
        })
      })
    }
}
struct MeddelandeView_Previews: PreviewProvider {
    static var previews: some View {
        
        MeddelandeView()
        
    }
}

class Appchat {
    var theText = ""
    var theMessageId = ""
    var theSenderId = ""
    var theSendername = ""
}

// rotate view
// add .flippedUpsideDown() on items do rotate(list, scrollview, osv)
struct FlippedUpsideDown: ViewModifier {
    func body(content: Content) -> some View {
        content
            .rotationEffect(.init(degrees: 180))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}
extension View{
    func flippedUpsideDown() -> some View{
        self.modifier(FlippedUpsideDown())
    }
}

//
//  AnsvarigView.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-05.
//

import SwiftUI

struct AnsvarigView: View {
    
  //  @State var test1 = false
    
  //  @State var test2 = false
    
    @State var isansvarig = true
    
    @StateObject var passlist = passCode()
    @StateObject var passlistReg = RegistreringCode()
    
    var body: some View {
        
        
        ZStack {
            (LinearGradient(gradient: Gradient (colors: [((/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.226, green: 0.259, blue: 0.315)/*@END_MENU_TOKEN@*/)), (Color.blue)]),startPoint: .topLeading, endPoint: .bottomTrailing))
                .ignoresSafeArea(edges: .top)
            
            VStack {
                
                HStack {
                    
                    Text("Alla sparade pass")
                        .font(.title3)
                        .foregroundColor(Color(hue: 0.588, saturation: 0.0, brightness: 0.96))
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color.blue)
                    Spacer()
                    
                    NavigationLink(destination: {
                        AddpassView()
                    }, label: {
                        Text("+ Lägg till")
                            .foregroundColor(Color(red: 0.232, green:0.231, blue: 0.244))
                            .padding(.all)
                            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: -0.236, green: 0.585, blue: 0.858)/*@END_MENU_TOKEN@*/)
                            .cornerRadius(40)
                            .shadow(radius: 10)
                    }).padding(.bottom)
                    
                    
                }
               
                /*
                 // Anroppa toggleStyle som vi gjorde på separat fil
                 Toggle("test1", isOn: $test1)
                 .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                 .toggleStyle(CheckmarkToggleStyle())
                 
                 Toggle("test2", isOn: $test2)
                 .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                 .toggleStyle(CheckmarkToggleStyle())
                 */
                
                
                List{
                    ForEach(passlist.allPasslist, id: \.allPassIds) { allpass in
                        
                        VStack {
                            HStack {
                                Text(allpass.allPassName)
                                    .foregroundColor(Color.white)
                                Spacer()
                                Text("ansv. \(allpass.passAnsvarignamn)")
                                    .foregroundColor(Color.blue)
                            }
                            
                            HStack {
                                Text(allpass.allPassDate)
                                    .foregroundColor(Color.white)
                                Spacer()
                                Text(allpass.allPassStart + " -")
                                
                                    .foregroundColor(Color.white)
                                Text(allpass.allPassEnd)
                                
                                    .foregroundColor(Color.white)
                                
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color.blue)
                            }
                            
                            //  .clipShape(RoundedRectangle(cornerRadius: 50))
                            
                           
                            
                        }
                    }
                    .onDelete(perform: deletepass)
                    .listRowBackground(Color.black)
                }
                .background(Color(red: 0.107, green: 0.102, blue: 0.102))
                .scrollContentBackground(Visibility.hidden)
                .cornerRadius(25)
                
            }.padding()
                .onAppear(){
                    passlist.getthepass()
                   
                }
              
                
            
            // visa loading vyn mellan det laddar alla pass
            if(passlist.isloading == true) {
                LoadingView()
            }

        }
        
    }
    
    func deletepass(at offsets: IndexSet){
        print("delete index")
        // för att veta rad index (index of delete row)
        let index = offsets[offsets.startIndex]
        print(index)
        // anroppa func som vi har i passCode
        passlist.deletefromfirebase(passidtodelete: passlist.allPasslist[index].allPassIds)
        passlist.allPasslist.remove(atOffsets: offsets)
    }
}

struct AnsvarigView_Previews: PreviewProvider {
    static var previews: some View {
        AnsvarigView()
    }
}

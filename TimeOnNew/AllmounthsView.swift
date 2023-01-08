//
//  AllmounthsView.swift
//  TimeOnNew
//
//  Created by Hasanen B on 2023-01-05.
//

import SwiftUI
import Firebase


struct AllmounthsView: View {
   
    var ref: DatabaseReference! = Database.database().reference()
    
    @State var allmonthsmaker = MinaPassView()
   
    @State var userAllmonths = [Timeinfo]()
    
    @StateObject var profilmaker = RegistreringCode()
    
    @State var anvNamn = ""
    @State var isShowingMailView = false
    @State var alertNoMail = false
    
    //mejl sheet
    @State var result: Result<MFMailComposeResult, Error>? = nil
   


    var body: some View {
        
        ZStack{
            Color.clear
                .ignoresSafeArea(edges: .top)
            
            
            VStack {
                HStack{
                    
                Text(anvNamn)
                    .font(.title3)
                    .padding(.horizontal)
                    .background(Color(hue: 0.577, saturation: 0.972, brightness: 0.847))
                    .cornerRadius(5)
                    .padding(.leading)
                    
                    Spacer()
                
                }
                    
                    Button(action: {
                        if MFMailComposeViewController.canSendMail() {
                            self.isShowingMailView.toggle()
                        } else {
                            alertNoMail = true
                            print("Can't send emails from this device")
                        }
                        if result != nil {
                            print("Result: \(String(describing: result))")
                        }
                    }) {
                        HStack {
                            Image(systemName: "envelope")
                            Text("Rapportera")
                        }.padding(.all)
                            .background(.black)
                            .cornerRadius(15)
                    }.padding(.top)
                
                        //   .disabled(!MFMailComposeViewController.canSendMail())
                      
                      .sheet(isPresented: $isShowingMailView) {
                          MailView(result: $result) { composer in
                              composer.setSubject("Antal timmar, \(allmonthsmaker.manad)")
                              composer.setToRecipients([""])
                              composer.setMessageBody("Hej!", isHTML: false)
                          }
                      }
                            .alert(isPresented: self.$alertNoMail) {
                                Alert(title: Text("NO MAIL SETUP"))
                            }
              
                List {
                    ForEach(userAllmonths, id: \.month){ pass in
                        
                        
                        HStack {
                            Text("\(pass.month) :")
                                .font(.title3)
                                .foregroundColor(Color.blue)
                            Spacer()
                            Text("\(pass.total) timmar")
                                .font(.title3)
                                .foregroundColor(Color.blue)
                            if(pass.month == allmonthsmaker.manad){
                                Image(systemName:"checkmark.seal.fill")
                                    .foregroundColor(Color.white)
                            }
                            else {
                                Image(systemName:"checkmark.seal.fill")
                                    .foregroundColor(Color.blue)
                            }
                        }
                    }
                    .listRowBackground(Color.black)
                }
            }
        }.background(LinearGradient(gradient: Gradient (colors: [((/*@START_MENU_TOKEN@*/Color(red: 0.232, green: 0.231, blue: 0.244)/*@END_MENU_TOKEN@*/)), (Color.blue)]),startPoint: .topLeading, endPoint: .bottomTrailing))
            .scrollContentBackground(Visibility.hidden)
        
            .onAppear() {
                
                profilmaker.getInfo() {
                    anvNamn = profilmaker.usersAppInfo.fullname
                }
            loadtotaltime()
        }
    }
    
    func loadtotaltime() {
        
        userAllmonths = []
        
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
        
            ref.child("Organisation").child(tempcurrentuser.orgkod).child("users").child("user totaltime").child(currentuserId).getData(completion: { error, snapshot in
            
            for child in snapshot!.children {
                
                let mounthSnapshot = child as! DataSnapshot
                
                let themounth = mounthSnapshot.value as! [String : Any]
                
                let thepassids = mounthSnapshot.key
                
              print(thepassids)
                let tempPass = Timeinfo()
                tempPass.id = currentuserId
               tempPass.month = themounth["datum"] as! String
               tempPass.total = themounth["Total timmar"] as! String
                userAllmonths.append(tempPass)
              
            }
        })
    }
  )}
}

struct AllmounthsView_Previews: PreviewProvider {
    static var previews: some View {
        AllmounthsView()
    }
}
import AVFoundation
import Foundation
import MessageUI
import SwiftUI
import UIKit

public struct MailView: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?
    public var configure: ((MFMailComposeViewController) -> Void)?

    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        public func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }

    public func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        configure?(vc)
        return vc
    }

    public func updateUIViewController(
        _ uiViewController: MFMailComposeViewController,
        context: UIViewControllerRepresentableContext<MailView>) {

    }
}

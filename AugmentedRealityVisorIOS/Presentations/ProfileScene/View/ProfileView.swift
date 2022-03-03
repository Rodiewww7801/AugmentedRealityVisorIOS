//
//  ProfileView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 03.03.2022.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel = ProfileViewModel()
    @EnvironmentObject var router: Router
    private let avatarSize: CGFloat = 100
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                HStack {
                    ZStack {
                        Circle()
                            .stroke(.black, lineWidth: 1)
                            .foregroundColor(.white)
                        
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: avatarSize * 0.5, height: avatarSize * 0.5)
                    }.frame(width: avatarSize, height: avatarSize)
                        .padding()
                    
                    VStack(alignment: .leading) {
                        Text("\(viewModel.userModel.firstName)")
                            .font(.system(size: 16))
                        
                        Divider()
                        
                        Text("\(viewModel.userModel.lastName)")
                            .font(.system(size: 16))
                        
                        Divider()
                    }
                }
                
                Text("Date of birth: \(viewModel.userModel.dateOfBirth.toString(with: "dd.MM.yyyy"))")
                    .font(.system(size: 16))
                
                Divider()
                
                if let companyName = viewModel.userModel.companyName {
                    Text("Company: \(companyName)")
                        .font(.system(size: 16))
                    
                    Divider()
                }
                
                if let stream = viewModel.userModel.stream {
                    Text("Stream: \(stream)")
                        .font(.system(size: 16))
                    
                    Divider()
                }
                
                if let secureLvl = viewModel.userModel.sequreLvl {
                    Text("Secure level: \(secureLvl)")
                        .font(.system(size: 16))
                    
                    Divider()
                }
                
                Button(action: {
                    withAnimation {
                        router.currentView = .loginView
                    }
                }, label: {
                    Text("Log out")
                        .foregroundColor(.red)
                        .font(.system(size: 16))
                    
                }).padding(.top)
                
                Spacer()
            }.padding()
        }
    }
}

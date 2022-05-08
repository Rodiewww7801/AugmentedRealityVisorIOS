//
//  SubscribeOnTopicView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 23.04.2022.
//

import SwiftUI

struct SubscribeOnTopicView: View {
    private var mqttManager = MQTTManager.shared()
    @Environment(\.presentationMode) var presentationMode
    @State var topic: String = ""
    
    var body: some View {
        VStack {
            Text("Subscribe on topic")
                .font(.title3)
            
            HStack {
                TextField("Enter topic", text: $topic)
                    .padding(.leading, 10)
                    .padding(5)
            }
                .background(
                    RoundedRectangle(cornerRadius: 23)
                        .foregroundColor(.gray.opacity(0.15)))
            
            Button(action: {
                mqttManager.subscribe(topic: topic)
                withAnimation {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }, label: {
                Text("Subscribe")
                    .font(.system(size: 16))
                    .padding()
                    .foregroundColor(.black)
                    .frame(width: 150, height: 40)
                    .overlay(RoundedRectangle(cornerRadius: 23)
                                .stroke(Color.black , lineWidth: 1))
                
            }).padding()
            
            Spacer()
        }.padding()
    }
}

struct SubscribeOnTopicView_Previews: PreviewProvider {
    static var previews: some View {
        SubscribeOnTopicView()
    }
}

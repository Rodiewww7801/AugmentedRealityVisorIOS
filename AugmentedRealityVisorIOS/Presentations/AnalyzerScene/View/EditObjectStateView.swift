//
//  EditObjectStateView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 24.04.2022.
//

import SwiftUI

import SwiftUI
import Alamofire

struct EditObjectStateView: View {
    var selectedValueObject: ObjectState
    var selectedTopic: String
    var mqttManager: MQTTManager = MQTTManager.shared()
    var pickerStates = [false, true]
    @State var objectState: Bool = false
    @State  var securityCheker: Bool = false
    @Binding var viewIsShown: Bool
     var firebaseManager: FirebaseManager = FirebaseManager._shared
    
    var body: some View {
        VStack {
            if securityCheker {
                Text("Enter value")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .padding(.top)
                
                HStack(alignment: .bottom) {
                    Text("\(selectedValueObject.name):")
                    
                    Picker("", selection: $objectState) {
                        ForEach(pickerStates, id: \.self) { state in
                            Text(state.description)
                        }
                    }.pickerStyle(.segmented)
                        .padding(.horizontal)
                }
                
                if let description = selectedValueObject.description {
                    HStack {
                        Text("\(description)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 5)
                        Spacer()
                    }
                }
                
                Button(action: {
                    //guard !doubleValueIsNotValid else { return }
                    guard let stringJSON = jsonEncoding(selectedValueObject) else {
                        self.viewIsShown.toggle()
                        //self.presentationMode.wrappedValue.dismiss()
                        return
                    }
                    
                    withAnimation {
                        mqttManager.publish(topic: selectedTopic + "/set", with: stringJSON)
                        self.viewIsShown.toggle()
                        //self.presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text("Save")
                        .font(.system(size: 16))
                        .padding()
                        .foregroundColor(.black)
                        .frame(width: 150, height: 40)
                        .overlay(RoundedRectangle(cornerRadius: 23)
                                    .stroke(Color.black , lineWidth: 1))
                })
                    .padding()
                    .padding(.bottom)
            }
        }.padding(.horizontal)
            .onAppear {
                firebaseManager.getUser(handler: { model in
                    securityCheker = model.securityLevel >= selectedValueObject.secureLevel
                })
                self.objectState = selectedValueObject.state
            }
    }
    
    func jsonEncoding(_ objectValue: ObjectState) -> String? {
        let objectValueDTO = ObjectStateDTO(name: objectValue.name,
                                            state: objectState,
                                            alarm: objectValue.alarm,
                                            description: objectValue.description,
                                            drawChart: objectValue.drawChart,
                                            hexColor: objectValue.hexColor)
        if let jsonData = try? JSONEncoder().encode(objectValueDTO) {
            let stringJSON = String(data: jsonData, encoding: .utf8)
            return stringJSON
        }
        return nil
    }
}


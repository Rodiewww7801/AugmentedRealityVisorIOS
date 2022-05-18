//
//  EditARItemObjectStateView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 18.05.2022.
//

import SwiftUI

struct EditARItemObjectStateView: View {
    var selectedValueObject: ObjectState
    var selectedTopic: String
    var mqttManager: MQTTManager = MQTTManager.shared()
    var pickerStates = [false, true]
    @State var objectState: Bool = false
    @Binding var viewIsShown: Bool
    var onDeleteAction: (()->Void)?
    
    var body: some View {
        VStack {
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
            
            Button(action: {
                onDeleteAction?()
                withAnimation {
                    self.viewIsShown.toggle()
                }
            }, label: {
                Text("Delete")
                    .font(.system(size: 16))
                    .padding()
                    .foregroundColor(.white)
                    .frame(width: 150, height: 40)
                    .background(RoundedRectangle(cornerRadius: 23)
                        .foregroundColor(.red))
            })
                .padding(.bottom)
        }.padding(.horizontal)
            .onAppear {
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

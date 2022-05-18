//
//  EditARItemObjectValueView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 18.05.2022.
//

import SwiftUI

struct EditARItemObjectValueView: View {
    var selectedValueObject: ObjectValue
    var selectedTopic: String
    var mqttManager: MQTTManager = MQTTManager.shared()
    @State var doubleValueIsNotValid: Bool = false
    @State var stringValue: String = ""
    @State var doubleValue: Double = 0.0
    @Binding var viewIsShown: Bool
    var onDeleteAction: (()->Void)?
    
    var body: some View {
        VStack {
            Text("Enter value")
                .font(.system(size: 16))
                .foregroundColor(.black)
                .padding(.top)
            
            HStack {
                Text("\(selectedValueObject.name):")
                
                HStack {
                    TextField("\(selectedValueObject.value)", text: Binding(get: {
                        stringValue
                    }, set: {
                        stringValue = $0
                        doubleValue =  alarmValidation( Double($0) ?? 0)
                    }))
                    .keyboardType(.decimalPad)
                    .font(.system(size: 16, weight: .regular))
                    .padding(.leading)
                    .padding(.vertical, 5)
                }.background(RoundedRectangle(cornerRadius: 23).foregroundColor(.gray.opacity(0.1)))
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
            
            if doubleValueIsNotValid {
                VStack(alignment: .leading) {
                    Text("Value not valide")
                    
                    if let hihi = selectedValueObject.alarmhihi {
                        Text("HiHi: \(hihi)")
                    }
                    
                    if let lolo = selectedValueObject.alarmlolo {
                        Text("LoLo: \(lolo)")
                    }
                }.font(.system(size: 16))
                    .foregroundColor(.red)
                    .padding()
                
            }
            
            Button(action: {
                guard !doubleValueIsNotValid else { return }
                guard let stringJSON = jsonEncoding(selectedValueObject) else {
                    self.viewIsShown.toggle()
                    return
                }
                
                withAnimation {
                    mqttManager.publish(topic: selectedTopic + "/set", with: stringJSON)
                    self.viewIsShown.toggle()
                }
            }, label: {
                Text("Save")
                    .font(.system(size: 16))
                    .padding()
                    .foregroundColor(.black)
                    .frame(width: 150, height: 40)
                    .overlay(RoundedRectangle(cornerRadius: 23)
                        .stroke(Color.black , lineWidth: 1))
            }).opacity(doubleValueIsNotValid ? 0.25 : 1)
                .disabled(doubleValueIsNotValid)
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
    }
    
    func jsonEncoding(_ objectValue: ObjectValue) -> String? {
        let objectValueDTO = ObjectValueDTO(name: selectedValueObject.name,
                                            value: doubleValue,
                                            alarmhihi: selectedValueObject.alarmhihi,
                                            alarmlolo: selectedValueObject.alarmlolo,
                                            description: selectedValueObject.description,
                                            drawChart: selectedValueObject.drawChart,
                                            hexColor: selectedValueObject.hexColor)
        if let jsonData = try? JSONEncoder().encode(objectValueDTO) {
            let stringJSON = String(data: jsonData, encoding: .utf8)
            return stringJSON
        }
        return nil
    }
    
    func alarmValidation(_ value: Double) -> Double {
        if let hihi = selectedValueObject.alarmhihi,
           value > hihi {
            doubleValueIsNotValid = true
            return hihi
        }
        
        if let lolo = selectedValueObject.alarmlolo,
           value < lolo {
            doubleValueIsNotValid = true
            return lolo
        }
        
        doubleValueIsNotValid = false
        return value
    }
}

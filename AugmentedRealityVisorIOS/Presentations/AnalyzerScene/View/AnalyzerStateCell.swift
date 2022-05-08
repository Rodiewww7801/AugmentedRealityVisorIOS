//
//  AnalyzerStateCell.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 24.04.2022.
//

import SwiftUI
import Charts

struct AnalyzerStateCell: View {
    var objectValue: ObjectState
    var topic: String
    @State var chartDatantries: [ChartDataEntry] = []
    @Binding var selectedObjectValue: ObjectState?
    @Binding var selectedTopic: String?
    @Binding var showEditObjectValue: Bool
    
    var body: some View {
        VStack {
            if objectValue.drawChart {
                LineChartViewRepresentable(entries: chartDatantries, hexColorChart: objectValue.hexColor)
                    
                    .frame(width: UIScreen.main.bounds.width, height: 250)
                    .padding(.bottom)
            }
            
            Button(action: {
                guard objectValue.isChange else { return }
                withAnimation {
                    self.selectedObjectValue = objectValue
                    self.selectedTopic = topic
                    self.showEditObjectValue.toggle()
                }
            }, label: {
                HStack {
                    Text("\(objectValue.name): ")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .onChange(of: objectValue) { newValue in
                            appendEntries(newValue)
                        }
                    
                    Text("\(objectValue.state.description)")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                    
                    Spacer()
                }
            }).padding(.horizontal)
            
            if let description = objectValue.description {
                HStack {
                    Text("\(description)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }.padding(.horizontal)
            }
            
            Divider()
        }
    }
    
    func appendEntries(_ objectValue: ObjectState)  {
        let dataChartEntry = ChartDataEntry(x: Double(objectValue.time.timeIntervalSince1970), y:  objectValue.state ? 1 : 0)
        chartDatantries.append(dataChartEntry)
    }
}

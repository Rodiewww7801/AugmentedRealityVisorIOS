//
//  ItemValueCell.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 03.05.2022.
//

import Foundation
import SwiftUI
import Charts

struct ItemValueCell: View {
    var topic: String
    var objectValue: ObjectValue
    @Binding var isShown: Bool
    @State var chartDatantries: [ChartDataEntry] = []
    @ObservedObject var arSceneViewModel: ARSceneViewModel
    
    var body: some View {
        Button(action: {
            self.appendARItem(objectValue: objectValue)
            self.isShown.toggle()
        }, label: {
            VStack() {
                if objectValue.drawChart {
                    LineChartViewRepresentable(entries: chartDatantries, hexColorChart: objectValue.hexColor)
                        .frame(width: UIScreen.main.bounds.width, height: 250)
                        .padding(.bottom)
                }
                
                HStack {
                    Text("\(objectValue.name): ")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .onChange(of: objectValue) { newValue in
                            appendEntries(newValue)
                        }
                    
                    Text("\(objectValue.value)")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                    
                    Spacer()
                }.padding(.horizontal)
                
                if let description = objectValue.description {
                    HStack {
                        Text("\(description)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }.padding(.horizontal)
                }
            }
        })
    }
    
    func appendEntries(_ objectValue: ObjectValue)  {
        let dataChartEntry = ChartDataEntry(x: Double(objectValue.time.timeIntervalSince1970), y:  objectValue.value)
        chartDatantries.append(dataChartEntry)
    }
    
    func appendARItem(objectValue: ObjectValue) {
        let viewModel = ARItemViewModel(topic: self.topic)
        arSceneViewModel.arItems.append(viewModel)
        viewModel.createValueView()
    }
}

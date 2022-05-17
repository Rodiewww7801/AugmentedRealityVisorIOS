//
//  ItemStateCell.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 03.05.2022.
//

import SwiftUI
import Charts

struct ItemStateCell: View {
    var topic: String
    var objectState: ObjectState
    @Binding var isShown: Bool
    @State var chartDatantries: [ChartDataEntry] = []
    @ObservedObject var arSceneViewModel: ARSceneViewModel
    
    var body: some View {
        Button(action: {
            self.appendARItem(objectValue: objectState)
            self.isShown.toggle()
        }, label: {
            VStack {
                if objectState.drawChart {
                    LineChartViewRepresentable(entries: chartDatantries, hexColorChart: objectState.hexColor)
                        .frame(width: UIScreen.main.bounds.width, height: 250)
                        .padding(.bottom)
                }
                
                HStack {
                    Text("\(objectState.name): ")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .onChange(of: objectState) { newValue in
                            appendEntries(newValue)
                        }
                    
                    Text("\(objectState.state.description)")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                    
                    Spacer()
                }.padding(.horizontal)
                
                if let description = objectState.description {
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
    
    func appendEntries(_ objectValue: ObjectState)  {
        let dataChartEntry = ChartDataEntry(x: Double(objectValue.time.timeIntervalSince1970), y:  objectValue.state ? 1 : 0)
        chartDatantries.append(dataChartEntry)
    }
    
    func appendARItem(objectValue: ObjectState) {
        let viewModel = ARItemViewModel(topic: self.topic)
        arSceneViewModel.arItemsViewModel.append(viewModel)
        viewModel.createStateView()
    }
}

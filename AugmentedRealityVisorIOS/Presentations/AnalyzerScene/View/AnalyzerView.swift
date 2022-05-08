//
//  AnalyzerView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 03.03.2022.
//

import SwiftUI
import Charts

struct AnalyzerView: View {
    @ObservedObject var viewModel: AnalyzerViewModel
    @State var searchItem: String = ""
    @State private var counter: Int = 0
    @State private var showSubscripeView: Bool = false
    @State private var showEditObjectValueView: Bool = false
    @State private var showEditObjectStateView: Bool = false
    @State private var dismissBottomSheetView: Bool = false
    @State private var selectedObjectValue: ObjectValue?
    @State private var selectedObjectState: ObjectState?
    @State private var selectedTopic: String?
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                SearchBar(searchItem: $searchItem)
                    .padding()
                
                Button(action: {
                    self.showSubscripeView.toggle()
                }, label: {
                    Text("Subscribe on topic")
                }).padding(.bottom)
                
                ScrollView(.vertical, showsIndicators: true) {
                    ForEach(viewModel.objectValues.sorted(by: >), id: \.key) { topic, object in
                        if searchItem.isEmpty || object.name.lowercased().contains(searchItem.lowercased()) {
                            AnalyzerValuesCell(objectValue: object,
                                             topic: topic,
                                             selectedObjectValue: $selectedObjectValue,
                                             selectedTopic: $selectedTopic,
                                             showEditObjectValue: $showEditObjectValueView)
                        }
                    }
                    
                    ForEach(viewModel.stateValues.sorted(by: >), id: \.key) { topic, object in
                        if searchItem.isEmpty || object.name.lowercased().contains(searchItem.lowercased()) {
                            AnalyzerStateCell(objectValue: object,
                                             topic: topic,
                                             selectedObjectValue: $selectedObjectState,
                                             selectedTopic: $selectedTopic,
                                             showEditObjectValue: $showEditObjectStateView)
                        }
                    }
                }
                
                Spacer()
            }
            
            if showEditObjectValueView,
                let topic = selectedTopic,
            let selectedObject = selectedObjectValue {
                BottomSheetView(showBottomSheetView: $showEditObjectValueView, dismissBottomSheetView: $dismissBottomSheetView) {
                    EditObjectValueView(selectedValueObject: selectedObject, selectedTopic: topic, viewIsShown: $showEditObjectValueView)
                }
            }
            
            if showEditObjectStateView,
                let topic = selectedTopic,
            let selectedObject = selectedObjectState {
                BottomSheetView(showBottomSheetView: $showEditObjectStateView, dismissBottomSheetView: $dismissBottomSheetView) {
                    EditObjectStateView(selectedValueObject: selectedObject, selectedTopic: topic, viewIsShown: $showEditObjectStateView)
                }
            }
        }.sheet(isPresented: $showSubscripeView) {
            SubscribeOnTopicView()
        }
    }
}

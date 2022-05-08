//
//  ARItemViewModel.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 05.05.2022.
//

import Foundation
import Charts
import SceneKit
import Combine
import UIKit
import SwiftUI

class ARItemViewModel: ObservableObject {
    @Published var node: SCNNode?
    @Published var objectState: ObjectState?
    @Published var objectValue: ObjectValue?
    @Published var entries: [ChartDataEntry] = []
    @Published var view: AnyView?
    @Published var uiView: UIView?
    @Published var controller: ARItemObjectValueUIView?
    let topic: String
    private let getMQTTValuesObjectsRepository: GetMQTTObjectRepository<ObjectValueDTO, Never>
    private let getMQTTStatesObjectsRepository: GetMQTTObjectRepository<ObjectStateDTO, Never>
    private var subscriptions = Set<AnyCancellable>()
    
    init(topic: String) {
        self.topic = topic
        self.getMQTTValuesObjectsRepository = GetMQTTObjectRepository<ObjectValueDTO, Never>(mqttManager: MQTTManager.shared())
        self.getMQTTStatesObjectsRepository = GetMQTTObjectRepository<ObjectStateDTO, Never>(mqttManager: MQTTManager.shared())
        //self.createStateView()
        //self.createValueView()
        
        self.getMQTTValuesObjectsRepository.subscribeTopic { [unowned self] result in
            switch result {
            case .success((let topic, let value)):
                if topic.lowercased() == self.topic.lowercased() {
                    self.objectValue = value
                    self.appendValueEntries(value)
                    updateValueView()
                }
            case .failure(let error) :
                print("Error to subscribe or decodable value: \(error.localizedDescription)")
            }
        }
        
        self.getMQTTStatesObjectsRepository.subscribeTopic { [unowned self] result in
            switch result {
            case .success((let topic, let value)):
                if topic.lowercased() == self.topic.lowercased() {
                    self.objectState = value
                    self.appendStateEntries(value)
                    updateStateView()
                }
            case .failure(let error) :
                print("Error to subscribe or decodable value: \(error.localizedDescription)")
            }
        }
    }
    
    private func appendValueEntries(_ objectValue: ObjectValue)  {
        let dataChartEntry = ChartDataEntry(x: Double(objectValue.time.timeIntervalSince1970), y:  objectValue.value)
        entries.append(dataChartEntry)
    }
    
    private func appendStateEntries(_ objectValue: ObjectState)  {
        let dataChartEntry = ChartDataEntry(x: Double(objectValue.time.timeIntervalSince1970), y:  objectValue.state ? 1 : 0)
        entries.append(dataChartEntry)
    }
    
    func createValueView() {
        self.view = AnyView(ARItemObjectValueView(arItemViewModel: self))

        let host = UIHostingController(rootView: self.view)
        if self.objectValue?.drawChart ?? false {
            host.view?.frame = CGRect(x: 0, y: 0, width: 500, height: 350)
        } else {
            host.view?.frame = CGRect(x: 0, y: 250, width: 300, height: 150)
        }
        
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.backgroundColor = .clear

        self.uiView = host.view
    }
    
    func createStateView() {
        self.view = AnyView(ARItemObjectStateView(arItemViewModel: self))

        let host = UIHostingController(rootView: self.view)
        if self.objectState?.drawChart ?? false {
            host.view?.frame = CGRect(x: 0, y: 0, width: 500, height: 350)
        } else {
            host.view?.frame = CGRect(x: 0, y: 250, width: 300, height: 150)
        }
        
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.backgroundColor = .clear

        self.uiView = host.view
    }
    
    private func updateValueView() {
        let host = UIHostingController(rootView: self.view)
        if self.objectValue?.drawChart ?? false {
            host.view?.frame = CGRect(x: 0, y: 0, width: 500, height: 350)
        } else {
            host.view?.frame = CGRect(x: 0, y: 250, width: 300, height: 150)
        }
        
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.backgroundColor = .clear

        self.uiView = host.view
    }
    
    private func updateStateView() {
        let host = UIHostingController(rootView: self.view)
        if self.objectState?.drawChart ?? false {
            host.view?.frame = CGRect(x: 0, y: 0, width: 500, height: 350)
        } else {
            host.view?.frame = CGRect(x: 0, y: 250, width: 300, height: 150)
        }
        
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.backgroundColor = .clear

        self.uiView = host.view
    }
}

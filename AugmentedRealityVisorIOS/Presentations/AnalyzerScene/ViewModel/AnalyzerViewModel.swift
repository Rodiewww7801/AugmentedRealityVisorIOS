//
//  AnalyzerViewModel.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 07.03.2022.
//

import Foundation
import Combine
import Charts


final class AnalyzerViewModel: ObservableObject {
    //todo: topic here and remove from Factory
    @Published var objects: [Object] = []
    @Published var objectValues: [String : ObjectValue ] = [ : ]
    @Published var stateValues: [String : ObjectState] = [ : ]
    @Published var entries: [ChartDataEntry] = []
    private let getMQTTValuesObjectsRepository: GetMQTTObjectRepository<ObjectValueDTO, Never>
    private let getMQTTStateObjectsRepository: GetMQTTObjectRepository<ObjectStateDTO, Never>
    private var subscription = Set<AnyCancellable>()
    
    init(getMQTTObjectsRepository: GetMQTTObjectRepository<ObjectValueDTO, Never>,
         getMQTTStateObjectsRepository: GetMQTTObjectRepository<ObjectStateDTO, Never>) {
        print("[AnalyzerViewModel] init")
        self.getMQTTValuesObjectsRepository = getMQTTObjectsRepository
        self.getMQTTStateObjectsRepository = getMQTTStateObjectsRepository
        
        self.getMQTTValuesObjectsRepository.subscribeTopic { [unowned self] result in
            switch result {
            case .success((let topic, let value)):
                self.objectValues[topic] = value
            case .failure(let error) :
                print("Error to subscribe or decodable value: \(error.localizedDescription)")
            }
        }
        
        self.getMQTTStateObjectsRepository.subscribeTopic { [unowned self] result in
            switch result {
            case .success((let topic, let value)) :
                self.stateValues[topic] = value
            case .failure(let error):
                print("Error to subscribe or decodable value: \(error.localizedDescription)")
            }
            
        }
    }
    
    deinit {
        print("[AnalyzerViewModel] deinit")
        entries = []
        objectValues = [:]
        stateValues = [:]
    }
    
    func appendEntries(_ objectValue: ObjectValue) {
        let dataChartEntry = ChartDataEntry(x: Double(objectValue.time.timeIntervalSince1970), y:  objectValue.value)
        entries.append(dataChartEntry)
    }
}

//
//  GetAllObjecetsRepository.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 07.03.2022.
//

import Foundation
import Combine

final class GetMQTTObjectRepository<Success: Decodable & ConvertModelProtocol, Failure: Error>: GetMQTTObjectRepositoryProtocol {
    var mqttManager: MQTTManager
    //private var mqttManeger: MQTTManager
    private var subscriptions = Set<AnyCancellable>()
    
    init(mqttManager: MQTTManager) {
        self.mqttManager = mqttManager
    }
    
    func subscribeTopic(selectedTopics: [String] = [], completion: @escaping (Result<(String, Success.Model), Failure>) -> Void) {
        //mqttManager.subscribe(topic: topic)
        mqttManager.$responseMessages.sink { responseMessages in
            for message in responseMessages.values {
                if selectedTopics.isEmpty {
                    if  let data = message.string.description.data(using: .utf8),
                        let dto = try? JSONDecoder().decode(Success.self, from: data) {
                        let object = dto.toModel()
                        completion(.success((message.topic, object)))
                    }
                } else {
                    if  selectedTopics.contains(where: { $0.lowercased() ==  message.topic.lowercased()}),
                        let data = message.string.description.data(using: .utf8),
                        let dto = try? JSONDecoder().decode(Success.self, from: data) {
                        let object = dto.toModel()
                        completion(.success((message.topic, object)))
                    }
                }
            }
        }.store(in: &subscriptions)
    }
}

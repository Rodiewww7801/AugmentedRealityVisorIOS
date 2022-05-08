//
//  LibraryViewModel.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 25.03.2022.
//

import Foundation
import Combine

final class LibraryViewModel: ObservableObject {
    @Published var object: Object?
    private let getMQTTObjectRepository: GetMQTTObjectRepository<ObjectDTO, Never>
    private var subscriptions = Set<AnyCancellable>()
    
    init(getMQTTObjectRepository: GetMQTTObjectRepository<ObjectDTO, Never>) {
        self.getMQTTObjectRepository = getMQTTObjectRepository
        
//        self.getMQTTObjectRepository.subscribeTopic(topic: "topic") { result in
//            switch result {
//            case .success(let value): self.object = value
//            default: break
//            }
//        })
    }
}

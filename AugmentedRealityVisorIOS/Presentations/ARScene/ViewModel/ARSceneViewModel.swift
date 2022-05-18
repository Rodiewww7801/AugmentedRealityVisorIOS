//
//  ARSceneViewModel.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 04.05.2022.
//

import Foundation
import ARKit
import SwiftUI
import FirebaseFirestoreSwift

class ARSceneViewModel: ObservableObject {
    @Published var showEditARItem: Bool = false
    @Published var qrCode: QRCodeModel?
    @Published var documentations: [DocumentationModel] = []
    @Published var startQRScan: Bool = false
    @Published var isQRProcess: Bool = false
    @Published var qrCodeAnchor: ARAnchor?
    @Published var arItemsViewModel: [ARItemViewModel] = []
    private let firebaseManager: FirebaseManager = FirebaseManager._shared
    
    @Published var showEditObjectValueView: Bool = false
    @Published var showEditObjectStateView: Bool = false
    @Published var selectedObjectValue: ObjectValue?
    @Published var selectedObjectState: ObjectState?
    @Published var selectedTopic: String?
    var onDeleteAction: (()->Void)?
    
    //todo: concurrency
    func getDocumetationsFromFirebase(qrCodeID: String) {
        self.documentations = []
        
        firebaseManager.firestore.collection("qrCodes").document(qrCodeID).getDocument { snapshot, error in
            
            if let data = snapshot?.data() {
                let documentationsIds = data["documents"] as? [String]
                
                documentationsIds?.forEach { documentId in
                    self.firebaseManager.firestore.collection("documents")
                        .document(documentId).getDocument { documentSnapshot, documentError in
                            
                            if let documentData = documentSnapshot?.data() {
                                let documentModel = DocumentationModel(name: documentData["name"] as? String ?? "nil",
                                                                       link: documentData["link"] as? String ?? "nil")
                                self.documentations.append(documentModel)
                            }
                        }
                }
            }
        }
    }
    
    func getARItemsFromFirebase(qrCodeID: String, completion: @escaping ()->Void) {
        var arItems: [ARItemModel]?
        
        firebaseManager.firestore
            .collection("qrCodes")
            .document(qrCodeID)
            .collection("arItems")
            .getDocuments { snapshot, error in
                arItems = snapshot?.documents.compactMap { (document) -> ARItemModel? in
                    return try? document.data(as: ARItemModel.self)
                }
                
                arItems?.forEach { arItem in
                    let viewModel = ARItemViewModel(topic: arItem.topic)
                    viewModel.arItem = arItem
                    viewModel.createValueView()
                    self.arItemsViewModel.append(viewModel)
                }
                
                completion()
            }
    }
    
    func saveARItemToFirebase(node: SCNNode, topic: String) {
        guard let qrCode = qrCode, let qrPosition = qrCode.postion else { return }
        
        let arItem = ARItemModel(
            id: node.name ?? UUID().uuidString,
            locationX: node.position.x - qrPosition.x,
            locationY: node.position.y - qrPosition.y,
            locationZ: node.position.z - qrPosition.z,
            topic: topic)
        
        try? firebaseManager.firestore
            .collection("qrCodes")
            .document(qrCode.id)
            .collection("arItems")
            .document(arItem.id)
            .setData(from: arItem)
    }
    
    func updateARItemToFirebase(node: SCNNode) {
        guard let qrCode = qrCode,
              let qrPosition = qrCode.postion,
              let nodeId = node.name else { return }
        
        firebaseManager.firestore
            .collection("qrCodes")
            .document(qrCode.id)
            .collection("arItems")
            .document(nodeId)
            .updateData([
                "locationX": node.position.x - qrPosition.x,
                "locationY": node.position.y - qrPosition.y,
                "locationZ": node.position.z - qrPosition.z
            ])
        
    }
    
    func removeARItemFromFirebase(node: SCNNode) {
        guard let qrCode = qrCode, let nodeId = node.name else { return }
        
        firebaseManager.firestore
            .collection("qrCodes")
            .document(qrCode.id)
            .collection("arItems")
            .document(nodeId)
            .delete()
        
    }
}

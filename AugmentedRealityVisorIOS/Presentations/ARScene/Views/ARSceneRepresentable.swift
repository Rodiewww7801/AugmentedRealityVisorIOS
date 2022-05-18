//
//  ARSceneRepresentable.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 30.04.2022.
//

import SwiftUI
import ARKit

struct ARSceneRepresentable: UIViewRepresentable {
    var arSceneViewModel: ARSceneViewModel
    var documentationListViewModel: DocumentationListViewModel
    private var arView: ARCustomView
    
    init(arSceneViewModel: ARSceneViewModel, documentationListViewModel: DocumentationListViewModel) {
        self.arSceneViewModel = arSceneViewModel
        self.documentationListViewModel = documentationListViewModel
        self.arView = ARCustomView(frame: .zero, arSceneViewModel: arSceneViewModel)
    }
    
    func makeUIView(context: Context) -> some ARSCNView {
        arView.delegate = context.coordinator
        arView.session.delegate = context.coordinator
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        arView.enableObjectPlacementable()
        arView.enableObjectSelectable()
        arView.enableObjectMoveable()
        arView.enableObjectScalable()
        arView.session.run(configuration)
        
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, arSceneViewModel: arSceneViewModel, documentationListViewModel: documentationListViewModel)
    }
    
    final class Coordinator: NSObject, ARSessionDelegate,  ARSCNViewDelegate {
        var sceneRepresentable: ARSceneRepresentable
        var arSceneViewModel: ARSceneViewModel
        var documentationListViewModel: DocumentationListViewModel
        
        init(_ sceneView: ARSceneRepresentable, arSceneViewModel: ARSceneViewModel, documentationListViewModel: DocumentationListViewModel) {
            self.documentationListViewModel = documentationListViewModel
            self.sceneRepresentable = sceneView
            self.arSceneViewModel = arSceneViewModel
        }
        
        func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            if arSceneViewModel.qrCodeAnchor?.identifier == anchor.identifier {
                let boxNode = SCNNode()
                boxNode.geometry = SCNBox(width: 0.04, height: 0.04, length: 0.04, chamferRadius: 0.0)
                boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                return boxNode
            }
            
            return nil
        }
        
        public func session(_ session: ARSession, didUpdate frame: ARFrame) {
            if arSceneViewModel.startQRScan {
                startDetectingQR(frame)
            }
        }
        
        private func startDetectingQR(_ frame: ARFrame) {
            if arSceneViewModel.isQRProcess {
                return
            }
            
            arSceneViewModel.isQRProcess = true
            
            let request = VNDetectBarcodesRequest { request, error in
                self.requestHandler(request: request, error: error, frame: frame)
            }
            
            request.symbologies = [.qr]
            let imageHandler = VNImageRequestHandler(cvPixelBuffer: frame.capturedImage, options: [:])
            try? imageHandler.perform( [request])
        }
        
        private func requestHandler(request: VNRequest, error: Error?, frame: ARFrame) {
            if let result = request.results?.first as? VNBarcodeObservation {
                guard let payload = result.payloadStringValue else { return }
                arSceneViewModel.qrCode = QRCodeModel(id: payload)
                
                var rect = result.boundingBox
                rect = rect.applying(CGAffineTransform(scaleX: 1, y: -1))
                rect = rect.applying(CGAffineTransform(translationX: 0, y: 1))
                
                let center = CGPoint(x: rect.midX, y: rect.midY)
                
                DispatchQueue.main.async {
                    self.raycastPlane(center: center, frame: frame)
                    self.arSceneViewModel.isQRProcess = false
                }
            } else {
                arSceneViewModel.isQRProcess = false
            }
        }
        
        private func raycastPlane(center: CGPoint, frame: ARFrame) {
            let hitTests = frame.hitTest(center, types: [.featurePoint])
            if let hitTest = hitTests.first {
                if let detectDataAnchor = arSceneViewModel.qrCodeAnchor,
                   let node = self.sceneRepresentable.arView.node(for: detectDataAnchor) {
                    node.transform = SCNMatrix4(hitTest.worldTransform)
                    self.clearAllNodes()
                } else {
                    let detectDataAnchor = ARAnchor(name: "QRAnchor", transform: hitTest.worldTransform)
                    self.sceneRepresentable.arView.session.add(anchor: detectDataAnchor)
                    arSceneViewModel.qrCodeAnchor = detectDataAnchor
                }
                
                arSceneViewModel.qrCode?.postion = SCNVector3(x: hitTest.worldTransform.columns.3.x,
                                                              y: hitTest.worldTransform.columns.3.y,
                                                              z: hitTest.worldTransform.columns.3.z)
                
                if let qrCodeID = arSceneViewModel.qrCode?.id {
                    arSceneViewModel.getDocumetationsFromFirebase(qrCodeID: qrCodeID)
                    arSceneViewModel.getARItemsFromFirebase(qrCodeID: qrCodeID) {
                        self.addARItems()
                    }
                }
                self.arSceneViewModel.startQRScan.toggle()
            }
        }
        
        private func clearAllNodes() {
            sceneRepresentable.arView.scene.rootNode.enumerateChildNodes { (node, stop) in
                    node.removeFromParentNode()
                }
        }
        
        private func addARItems() {
            arSceneViewModel.arItemsViewModel.forEach { item in
                guard let arItem = item.arItem,
                      let qrPosition = arSceneViewModel.qrCode?.postion else { return }
                
                let box = ARCustomView.createSCNBox(arItem: item)
                let node = SCNNode(geometry: box)
                
                let x = arItem.locationX + qrPosition.x
                let y = arItem.locationY + qrPosition.y
                let z = arItem.locationZ + qrPosition.z
                
                node.position = SCNVector3(x, y, z)
                
                //node look at camera
                if let currentFrame =  self.sceneRepresentable.arView.session.currentFrame {
                    node.eulerAngles.x = currentFrame.camera.eulerAngles.x
                    node.eulerAngles.y = currentFrame.camera.eulerAngles.y
                }
                
                node.name = arItem.id
                self.sceneRepresentable.arView.scene.rootNode.addChildNode(node)
            }
        }
    }
}

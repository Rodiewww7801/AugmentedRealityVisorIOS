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
    private var arView: ARCustomView
    
    init(arSceneViewModel: ARSceneViewModel) {
        self.arSceneViewModel = arSceneViewModel
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
        Coordinator(self, arSceneViewModel: arSceneViewModel)
    }
    
    final class Coordinator: NSObject, ARSessionDelegate,  ARSCNViewDelegate {
        var sceneRepresentable: ARSceneRepresentable
        var arSceneViewModel: ARSceneViewModel
        
        init(_ sceneView: ARSceneRepresentable, arSceneViewModel: ARSceneViewModel) {
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
//            if arSceneViewModel.isQRProcess {
//                return
//            }
//
//            arSceneViewModel.isQRProcess = true
//
//            let request = VNDetectBarcodesRequest { request, error in
//                self.requestHandler(request: request, error: error, frame: frame)
//            }
//
//            DispatchQueue.global(qos: .userInitiated).async {
//                request.symbologies = [.qr]
//                let imageHandler = VNImageRequestHandler(cvPixelBuffer: frame.capturedImage, options: [:])
//                try? imageHandler.perform( [request])
//            }
        }
        
        private func startDetectingQR(completionHandler: @escaping (VNRequest, Error?) -> Void) {
            //Create qr detection request
            let request = VNDetectBarcodesRequest(completionHandler: { request, error in
                completionHandler(request, error)
            })
            request.symbologies = [.qr]
        }
        
        private func requestHandler(request: VNRequest, error: Error?, frame: ARFrame) {
            if let result = request.results?.first as? VNBarcodeObservation {
                guard let _ = result.payloadStringValue else { return }
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
                } else {
                    let detectDataAnchor = ARAnchor(name: "QRAnchor", transform: hitTest.worldTransform)
                    self.sceneRepresentable.arView.session.add(anchor: detectDataAnchor)
                    arSceneViewModel.qrCodeAnchor = detectDataAnchor
                }
            }
        }
    }
}

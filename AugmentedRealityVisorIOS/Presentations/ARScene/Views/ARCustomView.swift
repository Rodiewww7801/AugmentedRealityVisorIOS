//
//  ARCustomView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 08.05.2022.
//

import Foundation
import ARKit
import SwiftUI

class ARCustomView: ARSCNView {
    private var arSceneViewModel: ARSceneViewModel
    private var panStartZ: CGFloat? = nil
    private var draggingNode: SCNNode? = nil
    
    required init(frame: CGRect, arSceneViewModel:ARSceneViewModel) {
        self.arSceneViewModel = arSceneViewModel
        super.init(frame: frame, options: nil)
    }
    
    required override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    @MainActor @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func enableObjectPlacementable() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func enableObjectSelectable() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    func enableObjectMoveable() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    func enableObjectScalable() {
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        self.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: self)
        
        if let hitTest = self.hitTest(location, types: .featurePoint).first {
            if let lastItem = arSceneViewModel.arItemsViewModel.last {
                let box = ARCustomView.createSCNBox(arItem: lastItem)
                let node = SCNNode(geometry: box)
                node.transform = SCNMatrix4(hitTest.worldTransform)
                
                //node look at camera
                if let currentFrame = self.session.currentFrame {
                    node.eulerAngles.x = currentFrame.camera.eulerAngles.x
                    node.eulerAngles.y = currentFrame.camera.eulerAngles.y
                }
                
                node.name = UUID().uuidString
                self.scene.rootNode.addChildNode(node)
                
                lastItem.arItem = ARItemModel(id: node.name ?? UUID().uuidString, locationX: node.position.x, locationY: node.position.y, locationZ: node.position.z, topic: lastItem.topic)
                
                arSceneViewModel.saveARItemToFirebase(node: node, topic: lastItem.topic)
            }
        }
    }
    
    @objc private func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        if arSceneViewModel.showEditObjectValueView ||
            arSceneViewModel.showEditObjectStateView {
            return
        }
        
        let notifyGenerator = UINotificationFeedbackGenerator()
        let location = recognizer.location(in: self)
        
        if let hitTest = self.hitTest(location, options: [:]).first {
            let selectedNode = hitTest.node
//            arSceneViewModel.arItemsViewModel.removeAll(where: {
//                $0.arItem?.id == selectedNode.name
//            })
            //arSceneViewModel.removeARItemFromFirebase(node: selectedNode)
            //selectedNode.removeFromParentNode()
            
            let selectedItem = arSceneViewModel.arItemsViewModel.first(where: { $0.arItem?.id == selectedNode.name})
            
            if let objectValue = selectedItem?.objectValue {
                arSceneViewModel.selectedObjectValue = objectValue
                arSceneViewModel.selectedTopic = selectedItem?.topic
                arSceneViewModel.showEditObjectValueView = true
                arSceneViewModel.onDeleteAction = { [weak self] in
                    self?.arSceneViewModel.arItemsViewModel.removeAll(where: {
                        $0.arItem?.id == selectedNode.name
                    })
                    self?.arSceneViewModel.removeARItemFromFirebase(node: selectedNode)
                    selectedNode.removeFromParentNode()
                }
            } else if let objectState = selectedItem?.objectState {
                arSceneViewModel.selectedObjectState = objectState
                arSceneViewModel.selectedTopic = selectedItem?.topic
                arSceneViewModel.showEditObjectStateView = true
                arSceneViewModel.onDeleteAction = { [weak self] in
                    self?.arSceneViewModel.arItemsViewModel.removeAll(where: {
                        $0.arItem?.id == selectedNode.name
                    })
                    self?.arSceneViewModel.removeARItemFromFirebase(node: selectedNode)
                    selectedNode.removeFromParentNode()
                }
            }
            
            notifyGenerator.notificationOccurred(.success)
        }
    }
    
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: self)
        
        switch recognizer.state {
        case .began:
            if let hitTest = self.hitTest(location, options: [:]).first {
                self.panStartZ = CGFloat(self.projectPoint(hitTest.node.worldPosition).z)
                self.draggingNode = hitTest.node
            }
        case .changed:
            if let panStartZ = self.panStartZ {
                let worldPosition = self.unprojectPoint(SCNVector3(location.x, location.y, panStartZ))
                self.draggingNode?.worldPosition = worldPosition
                if let draggingNode = draggingNode {
                    arSceneViewModel.updateARItemToFirebase(node: draggingNode)
                }
            }
        case .ended:
            self.panStartZ = nil
            self.draggingNode = nil
        default: break
        }
    }
    
    @objc private func handlePinch(recognizer: UIPinchGestureRecognizer) {
        let location = recognizer.location(in: self)
        
        if let hitTest = self.hitTest(location, options: [:]).first {
            if recognizer.state == .changed {
                let pinchScaleX = hitTest.node.scale.x * Float(recognizer.scale)
                let pinchScaleY = hitTest.node.scale.y * Float(recognizer.scale)
                let pinchScaleZ = hitTest.node.scale.z * Float(recognizer.scale)
                
                hitTest.node.scale = SCNVector3(pinchScaleX, pinchScaleY, pinchScaleZ)
                recognizer.scale = 1
            }
        }
    }
    
    static func createSCNBox(arItem: ARItemViewModel) -> SCNBox {
        let box: SCNBox
        //create box with chart or value view
        if (arItem.objectValue?.drawChart ?? false) ||
            (arItem.objectState?.drawChart ?? false) {
            box = SCNBox(width: 0.3, height: 0.2, length: 0.01, chamferRadius: 0.5)
        } else {
            box = SCNBox(width: 0.1, height: 0.05, length: 0.01, chamferRadius: 0.5)
        }
        
        box.firstMaterial?.diffuse.contents = arItem.uiView
        return box
    }
}

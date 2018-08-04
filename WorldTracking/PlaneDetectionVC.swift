//
//  PlaneDetectionVC.swift
//  WorldTracking
//
//  Created by Sudhanshu Srivastava on 01/08/18.
//  Copyright © 2018 Sudhanshu Srivastava. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class PlaneDetectionVC: UIViewController, ARSCNViewDelegate {
    static let storyboardId = "PlaneDetectionVC"
    
    @IBOutlet weak var sceneView: ARSCNView!
    var planes : [UUID: VirtualPlane] = [UUID: VirtualPlane]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
//        guard let scene = SCNScene(named: "art.scnassets/ObjectDetection.scn") else {return}
        let scene = SCNScene()
        sceneView.scene = scene
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap))
        sceneView.addGestureRecognizer(tapGR)
    }
    
    @objc private func handleScreenTap(_ tapGR: UITapGestureRecognizer) {
        guard let tappedSceneView = tapGR.view as? ARSCNView else { return }
        let tapLocation = tapGR.location(in: tappedSceneView)
        
        let planeIntersenctions = tappedSceneView.hitTest(tapLocation, types: [.existingPlaneUsingGeometry])
        if !planeIntersenctions.isEmpty {
            let firstHitTestResult = planeIntersenctions.first!
            guard let planeAnchor = firstHitTestResult.anchor as? ARPlaneAnchor else { return }
            if planeAnchor.alignment == .horizontal {
                // Add some item on horizontal plane
                addObjectToPlane(hitTestResult: firstHitTestResult, planeAnchor: planeAnchor)
            }
        }
    }
    
    private func addObjectToPlane (hitTestResult: ARHitTestResult, planeAnchor: ARPlaneAnchor) {
        let transform = hitTestResult.worldTransform
        let positionColumn = transform.columns.3
        let initialPosition = SCNVector3(positionColumn.x,
                                         positionColumn.y,
                                         positionColumn.z)
        
        let textScene = SCNText(string: "Sudhanshu", extrusionDepth: 0.5)
        textScene.firstMaterial?.diffuse.contents = UIColor.red
        let textNode = SCNNode(geometry: textScene)
        
        guard let plane = planes.first else { return }
        textNode.position = plane.value.position

        plane.value.addChildNode(textNode)
    }
 

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        let configuration = createARConfiguration()
        sceneView.session.run(configuration, options: [])
        
    }
    
    private func createARConfiguration() -> ARConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravity
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.isLightEstimationEnabled = true
//        configuration.providesAudioData = false // Experiment on it
        return configuration
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - ARSCNViewDelegate
    private func drawPlaneNode(anchor: ARPlaneAnchor, node: SCNNode) {
        let plane = VirtualPlane(anchor: anchor)
        self.planes[anchor.identifier] = plane
        node.addChildNode(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        drawPlaneNode(anchor: planeAnchor, node: node)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        drawPlaneNode(anchor: planeAnchor, node: node)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        //        plane.updateWithNewAnchor(planeAnchor)
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
    }
}


class VirtualPlane : SCNNode {
    var anchor: ARPlaneAnchor!
    var planeGeometry: SCNPlane!
    
    init (anchor: ARPlaneAnchor) {
        super.init()
        self.anchor = anchor
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        
        let material = initializePlaneMaterial()
        self.planeGeometry.materials = [material]
        
        let planeNode = SCNNode(geometry: self.planeGeometry)
        planeNode.position = SCNVector3(anchor.center.x, anchor.center.y, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-.pi/2, 1, 0, 0)
        planeNode.geometry?.firstMaterial?.isDoubleSided = true
        
        updatePlaneMaterialDimensions()
        
        self.addChildNode(planeNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initializePlaneMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
        return material
    }
    
    func updatePlaneMaterialDimensions() {
        let material = self.planeGeometry.materials.first!
        
        let width = self.planeGeometry.width
        let height = self.planeGeometry.height
        
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(width), Float(height), 1)
        self.planeGeometry.materials[0] = material
    }
    
    func updateWithNewAnchor (_ anchor: ARPlaneAnchor) {
        self.planeGeometry.width = CGFloat(anchor.extent.x)
        self.planeGeometry.height = CGFloat(anchor.extent.y)
        
        self.position = SCNVector3(anchor.center.x, anchor.center.y, anchor.center.z)
        
        updatePlaneMaterialDimensions()
    }
}

//
//  PlaneDetection1VC.swift
//  WorldTracking
//
//  Created by Sudhanshu Srivastava on 04/08/18.
//  Copyright © 2018 Sudhanshu Srivastava. All rights reserved.
//

import UIKit
import ARKit

class PlaneDetection1VC: UIViewController, ARSCNViewDelegate {
    static let storyboardId = "PlaneDetection1VC"
    
    @IBOutlet var sceneView: ARSCNView!
    var planeGeometry: SCNPlane!
    var planeIdentifiers = [UUID]()
    var anchors = [ARAnchor]()
    var sceneLight: SCNLight!
    
    private func createARConfiguration() -> ARConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        
        configuration.isLightEstimationEnabled = true
        configuration.worldAlignment = .gravity
        
        //        configuration.providesAudioData = false // Experiment on it
        
        return configuration
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.automaticallyUpdatesLighting = false // false, as we'll be using a custom light source
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        sceneLight = SCNLight()
        sceneLight.type = .omni
        
        let lightNode = SCNNode()
        lightNode.light = sceneLight
        lightNode.position = SCNVector3(0,10,2)
        
        sceneView.scene.rootNode.addChildNode(lightNode)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        let configuration = createARConfiguration()
        sceneView.session.run(configuration, options: [])
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let estimate = sceneView.session.currentFrame?.lightEstimate else { return }
        
        sceneLight.intensity = estimate.ambientIntensity
        
    }
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return nil }
        let node = SCNNode()
        planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        planeGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
        
        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.extent.z)
        planeNode.transform = SCNMatrix4MakeRotation(-.pi/2, 1, 0, 0)
        
        updateMaterial()
        
        node.addChildNode(planeNode)
        anchors.append(planeAnchor)
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        if anchors.contains(planeAnchor) {
            if node.childNodes.count > 0 {
                let planeNode = node.childNodes.first
                planeNode?.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
                
                if let plane = planeNode?.geometry as? SCNPlane {
                    plane.width = CGFloat(planeAnchor.extent.x)
                    plane.height = CGFloat(planeAnchor.extent.z)
                    updateMaterial()
                }
            }
        }
    }
    
    private func updateMaterial() {
        let material = self.planeGeometry.materials.first
        material?.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(self.planeGeometry.width), Float(self.planeGeometry.height), 1)
    }
    
    private func addNodeAtLocation(location: CGPoint) {
        guard anchors.count > 0 else { return }
        let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        if hitResults.count > 0 {
            let result = hitResults.first!
            let newLocation = SCNVector3(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y + 0.15, result.worldTransform.columns.3.z)
            
            let earthNode = EarthNode()
            earthNode.position = newLocation
            sceneView.scene.rootNode.addChildNode(earthNode)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: sceneView)
        addNodeAtLocation(location: location!)
    }

}

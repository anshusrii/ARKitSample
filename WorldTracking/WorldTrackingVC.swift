//
//  ViewController.swift
//  WorldTracking
//
//  Created by Sudhanshu Srivastava on 28/07/18.
//  Copyright © 2018 Sudhanshu Srivastava. All rights reserved.
//

import UIKit
import ARKit


class WorldTrackingVC: UIViewController {
    static let storyboardId = "WorldTrackingVC"
    @IBOutlet weak var sceneView: ARSCNView!
    
    // ARWorldTrackingConfiguration tracks position of the device relative to the real world.
    let configuration = ARWorldTrackingConfiguration()
    
    
    @IBAction func resetAction(_ sender: Any) {
        self.restartSession()
    }
    
    private func restartSession() {
        self.sceneView.session.pause()
        
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    fileprivate func addBox() {
        let node = SCNNode()
        
        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0) //  Give node a size for real world
        
        node.geometry?.firstMaterial?.specular.contents = UIColor.white // Give node a reflection color
        
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue // Give node a color
        
        node.position = SCNVector3(-0.3, -0.2, -0.5) // Values here are in meters w.r.t. World origin. 0.3 meters = 30 centi meters
        
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    fileprivate func addCapsule() {
        let node = SCNNode()
        node.geometry = SCNCapsule(capRadius: 0.1, height: 0.3)
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        node.position = SCNVector3(0,0,-0.3)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    fileprivate func addCone() {
        let node = SCNNode()
        node.geometry = SCNCone(topRadius: 0, bottomRadius: 0.3, height: 0.3) // topRadius=0 makes the top pointy.
//        node.geometry = SCNCone(topRadius: 0.1, bottomRadius: 0.1, height: 0.3) // topRadius=botomRadius makes it a cylinder
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        node.position = SCNVector3(0,0,-0.3)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    fileprivate func addCylinder() {
        let node = SCNNode()
        node.geometry = SCNCylinder(radius: 0.1, height: 0.3)
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        node.position = SCNVector3(0,0,-0.3)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    fileprivate func addSphere() {
        let node = SCNNode()
        node.geometry = SCNSphere(radius: 0.1)
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        node.position = SCNVector3(0,0,-0.3)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    fileprivate func addTube() {
        let node = SCNNode()
        node.geometry = SCNTube(innerRadius: 0.05, outerRadius: 0.15, height: 0.3)
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        node.position = SCNVector3(0,0,-0.3)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    fileprivate func addTorus() {
        let node = SCNNode()
        node.geometry = SCNTorus(ringRadius: 0.1, pipeRadius: 0.05)
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        node.position = SCNVector3(0,0,-0.3)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    fileprivate func addPlane() {
        let node = SCNNode()
        node.geometry = SCNPlane(width: 0.1, height: 0.3)
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        node.position = SCNVector3(0,0,-0.3)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    fileprivate func addPyramid() {
        let node = SCNNode()
        node.geometry = SCNPyramid(width: 0.1, height: 0.1, length: 0.1)
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        node.position = SCNVector3(0,0,-0.3)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    fileprivate func addBezierPath() {
        let node = SCNNode()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0.2))
        path.addLine(to: CGPoint(x: 0.2, y: 0.3))
        path.addLine(to: CGPoint(x: 0.4, y: 0.2))
        path.addLine(to: CGPoint(x: 0.4, y: 0))
        
        let shape = SCNShape(path: path, extrusionDepth: 0.2)
        node.geometry = shape
        
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        node.position = SCNVector3(0,0,-0.3)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    
    fileprivate func addHouse() {
        let doorNode = SCNNode(geometry: SCNPlane(width: 0.03, height: 0.06))
        doorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.brown
        
        let boxNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        
        let node = SCNNode()
        node.geometry = SCNPyramid(width: 0.1, height: 0.1, length: 0.1)
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        node.position = SCNVector3(0,0,-0.3)
        self.sceneView.scene.rootNode.addChildNode(node)
        
        boxNode.position = SCNVector3(0,-0.05,0)
        node.addChildNode(boxNode)
        
        doorNode.position = SCNVector3(0,-0.02,0.053)
        boxNode.addChildNode(doorNode)
        
        let cameraCoords = self.sceneView.getCameraCoordinates()
        node.position = SCNVector3Make(cameraCoords.x, cameraCoords.y, cameraCoords.z)
    }
    
    fileprivate func addText() {
        let textScene = SCNText(string: "Daksh", extrusionDepth: 0.2)
        textScene.firstMaterial?.diffuse.contents = UIColor.red
        textScene.firstMaterial?.isDoubleSided = true
        
        let cameraCoords = self.sceneView.getCameraCoordinates()
        
        let textNode = SCNNode(geometry: textScene)
        textNode.position = SCNVector3Make(cameraCoords.x, cameraCoords.y, cameraCoords.z)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    @IBAction func addNodeAction(_ sender: Any) {
        addText()
//        addHouse()
        
//        addBezierPath()
        
//        addPlane()
//        addPyramid()
//        addTorus()
//        addTube()
//        addSphere()
//        addCylinder()
//        addCone()
//        addCapsule()
//        addBox()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration, options: [])
        self.sceneView.autoenablesDefaultLighting = true // Gives the world a light source.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}


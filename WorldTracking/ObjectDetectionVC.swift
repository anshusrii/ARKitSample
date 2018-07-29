//
//  ObjectDetectionVC.swift
//  WorldTracking
//
//  Created by Sudhanshu Srivastava on 29/07/18.
//  Copyright © 2018 Sudhanshu Srivastava. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ObjectDetectionVC: UIViewController, ARSCNViewDelegate {
    
    static let storyboardId = "ObjectDetectionVC"
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        // Do any additional setup after loading the view.
        
        guard let scene = SCNScene(named: "art.scnassets/ObjectDetection.scn") else {return}
        sceneView.scene = scene
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "WatterBottle", bundle: Bundle.main)!
        sceneView.session.run(configuration, options: [])
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    
    // MARK: ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        // On iOS 12 on-wards we can use ARObjectAnchor too
        if let _ = anchor as? ARImageAnchor {
            let alert = UIAlertController.init(title: "Detection Result", message: "Bottle detected", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Okay", style: .cancel))
            self.present(alert, animated: true)
            
            /*
            let plane = SCNPlane(width: CGFloat(objectAnchor.referenceImage.physicalSize.height * 0.8), height: CGFloat(objectAnchor.referenceImage.physicalSize.width * 0.5))
            plane.cornerRadius = plane.width/8
            
            let spritKitScene = SKScene(fileNamed: "ProductInfo")
            
            plane.firstMaterial?.diffuse.contents = spritKitScene
            plane.firstMaterial?.isDoubleSided = true
            
            plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.position = SCNVector3Make(Float(objectAnchor.referenceImage.physicalSize.width/2), Float(objectAnchor.referenceImage.physicalSize.width/2), 0)
            node.addChildNode(planeNode)
            */
        }
        return node
    }
    
    
}

//
//  SelectOptionsVC.swift
//  WorldTracking
//
//  Created by Sudhanshu Srivastava on 29/07/18.
//  Copyright © 2018 Sudhanshu Srivastava. All rights reserved.
//

import UIKit
import ARKit

class SelectOptionsVC: UITableViewController {

    let optionsArr : [String] = ["Word Tracking", "Object Detection"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Augmented Reality"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        (self.view as! UITableView).register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return optionsArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.textLabel?.text = optionsArr[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            guard let vc = storyboard?.instantiateViewController(withIdentifier: WorldTrackingVC.storyboardId) else {return}
            vc.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 1:
            guard let vc = storyboard?.instantiateViewController(withIdentifier: ObjectDetectionVC.storyboardId) else {return}
            vc.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        default:
            break
        }
    }

}

extension Float {
    static func random(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
}

extension ARSCNView {
    struct MyCameraCoordinates {
        var x = Float()
        var y = Float()
        var z = Float()
    }
    
    func getCameraCoordinates () -> MyCameraCoordinates {
        guard let cameraTransform = self.session.currentFrame?.camera.transform else {return MyCameraCoordinates(x: 0, y: 0, z: 0) }
        
        let cameraCoordinates = MDLTransform(matrix: cameraTransform) // Model Transform
        
        var cc = MyCameraCoordinates()
        cc.x = cameraCoordinates.translation.x
        cc.y = cameraCoordinates.translation.y
        cc.z = cameraCoordinates.translation.z - 0.2
        
        return cc
    }
}


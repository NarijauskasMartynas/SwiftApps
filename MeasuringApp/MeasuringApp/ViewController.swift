//
//  ViewController.swift
//  MeasuringApp
//
//  Created by Martynq on 07/11/2019.
//  Copyright © 2019 Martynq. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dotsArray : [SCNNode] = []
    
    let textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegat
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
        sceneView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if dotsArray.count >= 2 {
            for dot in dotsArray{
                dot.removeFromParentNode()
            }
            dotsArray = [SCNNode]()
        }
        
        if let firstTouch = touches.first?.location(in: sceneView){
            let touchResults = sceneView.hitTest(firstTouch, types: .featurePoint)
            if let touchResult = touchResults.first{
                addDotToScene(at: touchResult)
            }
        }
    }
    
    func addDotToScene(at location: ARHitTestResult){
        let sphere = SCNSphere(radius: 0.005)
        
        let sphereMaterials = SCNMaterial()
        sphereMaterials.diffuse.contents = UIColor.red
        
        sphere.materials = [sphereMaterials]
        
        let sphereNode = SCNNode()
        sphereNode.geometry = sphere
        
        sphereNode.position = SCNVector3(location.worldTransform.columns.3.x, location.worldTransform.columns.3.y, location.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(sphereNode)
        
        dotsArray.append(sphereNode)
        
        if dotsArray.count >= 2{
            calculate()
        }
    }
    
    func calculate(){
        let start = dotsArray[0]
        let end = dotsArray[1]
        
        let distance = sqrt(pow(start.position.x - end.position.x, 2) +
                            pow(start.position.y - end.position.y, 2) +
                            pow(start.position.z - end.position.z, 2))

        addText(text: "\(distance)", location: end.position)
    }
    
    func addText(text : String, location: SCNVector3){
        
        textNode.removeFromParentNode()
        
        let textGeometry = SCNText(string: text, extrusionDepth: 0.1)
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode.geometry = textGeometry
        
        textNode.position = SCNVector3(location.x, location.y + 0.01, location.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
}

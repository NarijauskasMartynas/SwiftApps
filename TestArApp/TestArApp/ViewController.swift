//
//  ViewController.swift
//  TestArApp
//
//  Created by Martynq on 05/11/2019.
//  Copyright © 2019 Martynq. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    private var dicesArray : [SCNNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
       
        addPlanetsObjects()
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        configuration.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
     
        guard let planeAnchor = anchor as? ARPlaneAnchor else{return}
        
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        let planeNode = SCNNode()
        
        let gridMaterial = SCNMaterial()
        
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        
        plane.materials = [gridMaterial]
        
        planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi*0.5, 1, 0, 0)
        
        planeNode.geometry = plane
        
        node.addChildNode(planeNode)
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            
            let location = touch.location(in: sceneView)
            
            let touchResult = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
            
            addDiceOnClick(touchResult: touchResult)
        }
    }
    
    func addDiceOnClick(touchResult : [ARHitTestResult]){
        if let result = touchResult.first{
            let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")
                   
                if let diceNode = diceScene?.rootNode.childNode(withName: "Dice", recursively: true){
                    diceNode.position = SCNVector3(result.worldTransform.columns.3.x,
                                                      result.worldTransform.columns.3.y + diceNode.boundingSphere.radius/2,
                                                      result.worldTransform.columns.3.z)
                    sceneView.scene.rootNode.addChildNode(diceNode)
                    rollDice(dice: diceNode)
                   
                    dicesArray.append(diceNode)
                   }
            
        }
    }
    
    func addPlanetsObjects(){
        
       let sphere = SCNSphere(radius: 0.2)
       
       let material = SCNMaterial()
       
       material.diffuse.contents = UIImage(named: "art.scnassets/8k_moon.jpg")
       
       sphere.materials = [material]
       
       let sun = SCNSphere(radius: 0.3)
       
       let sunMaterial = SCNMaterial()
       
       sunMaterial.diffuse.contents = UIImage(named: "art.scnassets/8k_sun.jpg")
       
       sun.materials = [sunMaterial]
       
       let node = SCNNode()
       
       let sunNode = SCNNode()
       
       sunNode.position = SCNVector3(x: 0.0, y: 0.1, z: -4.0)
       
       sunNode.geometry = sun
       
       node.position = SCNVector3(x: 0.0, y: 0.1, z: -0.5)
       
       node.geometry = sphere
       
       sceneView.scene.rootNode.addChildNode(node)
       
       sceneView.scene.rootNode.addChildNode(sunNode)
    }
    
    //MARK: -  Dices logic
    
    func rollAllDices(){
        if !dicesArray.isEmpty{
            for dice in dicesArray{
                rollDice(dice: dice)
            }
        }
    }
    
    func rollDice(dice: SCNNode){
        let randomX = Float(arc4random_uniform(6)) * Float.pi/2
        let randomZ = Float(arc4random_uniform(6)) * Float.pi/2
                               
        dice.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomZ * 5), duration: 0.5))
                               
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAllDices()
    }
    
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        rollAllDices()
    }
    
    @IBAction func removeDicesTapped(_ sender: UIBarButtonItem) {
        if !dicesArray.isEmpty{
            for dice in dicesArray{
                dice.removeFromParentNode()
            }
        }
    }
}

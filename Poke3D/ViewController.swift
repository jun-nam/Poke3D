//
//  ViewController.swift
//  Poke3D
//
//  Created by June Nam on 10/1/19.
//  Copyright © 2019 Jun Nam. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 10
            print("Images Successfully Added")
        }
        

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        print("renderer was called!")
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            print("Image detected : \(imageAnchor.referenceImage.name!)")
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.7)
            
            let planeNode = SCNNode(geometry: plane)
            
            //rotate 90 degress anti-clockwise
            planeNode.eulerAngles.x = -.pi/2
            
            node.addChildNode(planeNode)
            
            addPokemon(card: planeNode, pokemonName: imageAnchor.referenceImage.name!.replacingOccurrences(of: "-card", with: ""))
        }
        
        return node
    }
    
    func addPokemon(card planeNode : SCNNode, pokemonName : String) {
        if let pokeScene = SCNScene(named: "art.scnassets/\(pokemonName)/\(pokemonName).scn") {
            if let pokeNode = pokeScene.rootNode.childNodes.first {
                pokeNode.eulerAngles.x += .pi/2
                planeNode.addChildNode(pokeNode)
            }
        }
    }

}

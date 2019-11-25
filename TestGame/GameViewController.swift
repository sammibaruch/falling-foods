//
//  GameViewController.swift
//  TestGame
//
//  Created by Sammi Baruch on 11/14/19.
//  Copyright © 2019 Sammi Baruch. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit
import GameplayKit

// declare global variables
var mouthIsOpen = false


class GameViewController: UIViewController {
    
    let trackingView = ARSCNView()
    let mouthPositionLabel = UILabel()
    let counterLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = StartScene(size: view.bounds.size, characterType: "cactus")
        
        let view = self.view as! SKView
        view.showsFPS = true
        view.showsNodeCount = true
        view.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        view.presentScene(scene)
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("ARKit is not supported on this device")
        }
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
            if (granted) {
                DispatchQueue.main.sync {
                    self.setupMouthTracker()
                }
            } else {
                fatalError("This app needs Camera Access to function. You can grant access in Settings.")
            }
        }
    }
    
    func setupMouthTracker() {
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        trackingView.session.run(configuration)
        trackingView.delegate = self as? ARSCNViewDelegate
        
        view.addSubview(trackingView)
    }
    
    func handleMouth(mouthValue: CGFloat) {
        switch mouthValue {
        case _ where mouthValue > 0.15:
            mouthIsOpen = true
            character.texture = SKTexture(imageNamed: "tester-open")
        default:
            mouthIsOpen = false
            character.texture = SKTexture(imageNamed: "tester-close")
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        let jawOpenValue = faceAnchor.blendShapes[.jawOpen] as! CGFloat
    
        DispatchQueue.main.async {
            self.handleMouth(mouthValue: jawOpenValue)
        }
    }
}

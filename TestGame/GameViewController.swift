//
//  GameViewController.swift
//  TestGame
//
//  Created by Sammi Baruch on 11/14/19.
//  Copyright © 2019 Sammi Baruch. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = StartScene(size: view.bounds.size, characterType: "cactus")

        let view = self.view as! SKView
        view.showsFPS = true
        view.showsNodeCount = true
        view.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        view.presentScene(scene)
        
        
        }
    
    override var prefersStatusBarHidden: Bool {
            return true
        }
    
    }

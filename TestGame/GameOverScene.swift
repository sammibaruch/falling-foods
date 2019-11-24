//
//  GameOverScene.swift
//  TestGame
//
//  Created by Sammi Baruch on 11/24/19.
//  Copyright © 2019 Sammi Baruch. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    var theme = "cactus"
    
    init(size: CGSize, score:Int, characterType: String) {
        self.theme = characterType
        super.init(size: size)
        
        let background = SKSpriteNode(imageNamed: theme+"Background")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.anchorPoint = CGPoint(x: 0.5, y:0.5)
        background.zPosition = -10000
        addChild(background)
        
        
        
        let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Your Score: " + String(score)
        scoreLabel.fontSize = 40
        //        scoreLabel.fontColor = SKColor.blue
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height*3/4)
        
        addChild(scoreLabel)
        
        let againLabel = SKLabelNode(fontNamed: "Chalkduster")
        againLabel.text = "Play Again"
        againLabel.fontSize = 35
        //        againLabel.fontColor = SKColor.black
        againLabel.position = CGPoint(x: size.width/2, y: size.height/4)
        againLabel.name = "again"
        
        addChild(againLabel)
        
        let homeLabel = SKLabelNode(fontNamed: "Chalkduster")
        homeLabel.text = "Home"
        homeLabel.fontSize = 35
        homeLabel.fontColor = SKColor.black
        homeLabel.position = CGPoint(x: size.width/2, y: size.height/7)
        homeLabel.name = "home"
        
        addChild(homeLabel)
        
        if theme == "moon" {
            scoreLabel.fontColor = SKColor.yellow
            againLabel.fontColor = SKColor.white
            homeLabel.fontColor = SKColor.white
        }
        else {
            scoreLabel.fontColor = SKColor.blue
            againLabel.fontColor = SKColor.black
            homeLabel.fontColor = SKColor.black
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if let name = touchedNode.name {
            if name == "again" {
                run(SKAction.sequence([
                    SKAction.run() { [weak self] in
                        guard let `self` = self else {return}
                        let reveal = SKTransition.flipVertical(withDuration: 0.5)
                        let scene = GameScene(size: self.size, characterType: self.theme)
                        self.view?.presentScene(scene, transition:reveal)
                    }
                    ]))
            }
                
            else if name == "home" {
                run(SKAction.sequence([
                    SKAction.run() { [weak self] in
                        guard let `self` = self else {return}
                        let reveal = SKTransition.flipVertical(withDuration: 0.5)
                        let scene = StartScene(size: self.size, characterType: self.theme)
                        self.view?.presentScene(scene, transition:reveal)
                    }
                    ]))
            }
        }
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

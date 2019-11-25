//
//  StartScene.swift
//  TestGame
//
//  Created by Sammi Baruch on 11/22/19.
//  Copyright © 2019 Sammi Baruch. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import GameplayKit

class StartScene: SKScene {
    
    //private var character = SKSpriteNode()
    //private var characterChangingFrames: [SKTexture] = []
    let background = SKSpriteNode(imageNamed: "cactusBackground")
    let nameLabel = SKLabelNode()
    let startLabel = SKLabelNode()
    var theme = "cactus"

    init(size: CGSize, characterType: String) {
        super.init(size: size)
        
        // set the theme
        theme = characterType
        background.size = self.size
        background.texture = SKTexture(imageNamed: theme+"Background")
        if theme == "moon" {
            nameLabel.fontColor = SKColor.yellow
            startLabel.fontColor = SKColor.white
        }
        else {
            nameLabel.fontColor = SKColor.blue
            startLabel.fontColor = SKColor.black
        }
        
        // set up the background
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.anchorPoint = CGPoint(x: 0.5, y:0.5)
        background.zPosition = -10000
        addChild(background)
        
        // add the character to the screen
//        buildCharacter(character: theme)
//        animateCharacter(character: theme)
        character.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(character)
        
        // set up the name label
        nameLabel.text = "Falling Foods!"
        nameLabel.fontName = "Georgia"
        nameLabel.fontSize = 40
        nameLabel.position = CGPoint(x: size.width/2, y: size.height*3/4)
        nameLabel.zPosition = 100
        addChild(nameLabel)
        
        // set up the start game label/button
        startLabel.text = "Start Game"
        startLabel.fontName = "Georgia"
        startLabel.fontSize = 35
        startLabel.position = CGPoint(x: size.width/2, y: size.height*1/4)
        startLabel.name = "start"
        startLabel.isUserInteractionEnabled = false
        startLabel.zPosition = 100
        addChild(startLabel)
        
        // set up the cactus theme label/button
        let cactusTheme = SKSpriteNode(imageNamed: "cactusSmall")
        cactusTheme.position = CGPoint(x: size.width*2/3, y: size.height/6)
        cactusTheme.name = "cactusTheme"
        addChild(cactusTheme)
        
        // set up the moon theme label/button
        let moonTheme = SKSpriteNode(imageNamed: "moonSmall")
        moonTheme.position = CGPoint(x: size.width/3, y: size.height/6)
        moonTheme.name = "moonTheme"
        addChild(moonTheme)
        
        // run addFood() forever
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addFood),
                SKAction.wait(forDuration:1.0)
                ])
        ))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        // if user touches start button - move to GameScene (send theme info)
        if let name = touchedNode.name {
            if name == "start" {
                character.removeFromParent()
                run(SKAction.sequence([
                    SKAction.run() { [weak self] in
                        guard let `self` = self else {return}
                        let reveal = SKTransition.flipVertical(withDuration: 0.5)
                        let scene = GameScene(size: self.size, characterType: self.theme)
                        self.view?.presentScene(scene, transition:reveal)
                    }
                    ]))
            }
            
            // user touches moonTheme button - change theme to moon
            else if name == "moonTheme" {
                // change theme
                theme = "moon"
               
                // change background
                background.texture = SKTexture(imageNamed: "moonBackground")
                
                // change label colors
                nameLabel.fontColor = SKColor.yellow
                startLabel.fontColor = SKColor.white
                
                // remove the old character and build new character
//                character.removeFromParent()
//                buildCharacter(character: theme)
//                animateCharacter(character: theme)
            }
            
            // if user touches cactusTheme button - change theme to cactus
            else if name == "cactusTheme" {
                // change theme
                theme = "cactus"
                
                // change background
                background.texture = SKTexture(imageNamed: "cactusBackground")
                
                // change label colors
                nameLabel.fontColor = SKColor.blue
                startLabel.fontColor = SKColor.black
                
                // remove the old character and build new character
//                character.removeFromParent()
//                buildCharacter(character: theme)
//                animateCharacter(character: theme)
                
            }
        }
        
    }
    
    func randomFood() -> String {
        let rand = Int.random(in: 0 ..< 5)
        let foods = ["burrito", "ice-cream", "lolly", "burger", "pepper"]
        return foods[rand]
    }
    
    func addFood() {
        let food = SKSpriteNode(imageNamed: randomFood())
        food.zPosition = -100
        // determine random x value for food to fall from
        let actualX = CGFloat.random(in: food.size.width/2 ... (size.width - food.size.width/2))

        food.position = CGPoint(x: actualX, y: size.height + food.size.height/2)
        
        addChild(food)
        
        let actualDuration = Float.random(in: 2.0 ... 4.0)

        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -food.size.height/2), duration:
            TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        
        food.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
//    func buildCharacter(character char: String) {
//        let characterAnimatedAtlas = SKTextureAtlas(named: char+"Images")
//        var characterFrames: [SKTexture] = []
//
//        let numImages = characterAnimatedAtlas.textureNames.count
//        for i in 1...numImages {
//            let characterTextureName = char+"\(i)"
//            characterFrames.append(characterAnimatedAtlas.textureNamed(characterTextureName))
//        }
//        characterChangingFrames = characterFrames
//
//        let firstFrameTexture = characterChangingFrames[0]
//        character = SKSpriteNode(texture: firstFrameTexture)
//        character.position = CGPoint(x: frame.midX, y: frame.midY)
//        addChild(character)
//
//    }
//
//    func animateCharacter(character char: String) {
//        character.run(SKAction.repeatForever(
//            SKAction.animate(with: characterChangingFrames,
//                             timePerFrame: 0.1,
//                             resize: true,
//                             restore: true)),
//                      withKey:"ChangingSize")
//    }
    
    func addPhrase() {
        let phrase = SKSpriteNode(imageNamed: randomFood())
        phrase.zPosition = -10
        
        phrase.position = CGPoint(x: size.width/2, y: size.height/6)
        
        addChild(phrase)
        
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

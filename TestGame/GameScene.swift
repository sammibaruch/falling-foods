//
//  GameScene.swift
//  TestGame
//
//  Created by Sammi Baruch on 11/14/19.
//  Copyright © 2019 Sammi Baruch. All rights reserved.
//

import SpriteKit
import GameplayKit
import ARKit
import Foundation

// declare global variables
let character = SKSpriteNode(imageNamed: "tester-close")

struct PhysicsCategory {
    static let none     : UInt32 = 0
    static let all      : UInt32 = UInt32.max
    static let food     : UInt32 = 0b1
    static let character   : UInt32 = 0b10
    
}

class GameScene: SKScene {
    
    var lives = 3
    var foodEaten = 0
//    let character = SKSpriteNode(imageNamed: "tester-close")
    let scoreLabel = SKLabelNode()
    let lifeLabel = SKLabelNode()
    let background = SKSpriteNode(imageNamed: "cactusBackground")
    var theme = "cactus"
    
    init(size: CGSize, characterType: String) {
        super.init(size: size)
        
        theme = characterType
        character.texture = SKTexture(imageNamed: "tester-close")
        background.texture = SKTexture(imageNamed: theme+"Background")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    override func didMove(to view: SKView) {
        
        // reset score and lives
        foodEaten = 0
        lives = 3
        
        // set up the background
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.anchorPoint = CGPoint(x: 0.5, y:0.5)
        background.zPosition = -10000
        addChild(background)
        
        // set up the score label
        scoreLabel.text = String(foodEaten)
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = SKColor.yellow
        scoreLabel.color = SKColor.white
        scoreLabel.position = CGPoint(x: size.width/10, y: size.height * 0.95)
        addChild(scoreLabel)
        
        // set up the lives label
        lifeLabel.text = ""
        lifeLabel.fontName = "Helvetica"
        lifeLabel.fontSize = 30
        lifeLabel.fontColor = SKColor.red
        lifeLabel.color = SKColor.white
        lifeLabel.position = CGPoint(x: (size.width * 9)/10, y: size.height * 0.95)
        addChild(lifeLabel)
        
        // add the character to the screen
        character.position = CGPoint(x: size.width * 0.5, y:size.height * 0.2)
        character.zPosition = -100
        character.name = "character"
        character.physicsBody = SKPhysicsBody(rectangleOf: character.size)
        character.physicsBody?.isDynamic = true
        character.physicsBody?.categoryBitMask = PhysicsCategory.character
        character.physicsBody?.contactTestBitMask = PhysicsCategory.food
        character.physicsBody?.collisionBitMask = PhysicsCategory.none
        character.physicsBody?.usesPreciseCollisionDetection = true
        addChild(character)
        
        // turn on phyiscs - no gravity
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        // run addFood() forever
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addFood),
                SKAction.wait(forDuration:1.0)])
        ))
        
//        run(SKAction.repeatForever(
//            SKAction.sequence([
//                SKAction.run(checkMouthPosition)
//                ])
//        ))
        
        // add background music
        let backgroundMusic = SKAudioNode(fileNamed: "background.wav")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    func randomFood() -> String {
        let rand = Int.random(in: 0 ..< 5)
        let foods = ["burrito", "ice-cream", "pizza", "burger", "pepper"]
        return foods[rand]
    }
    
    func addFood() {

        let randFood = randomFood()
        let food = SKSpriteNode(imageNamed: randFood)
        food.name = randFood
        
        food.physicsBody = SKPhysicsBody(rectangleOf: food.size)
        food.physicsBody?.isDynamic = true
        food.physicsBody?.categoryBitMask = PhysicsCategory.food
        food.physicsBody?.contactTestBitMask = PhysicsCategory.character
        food.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        let actualX = CGFloat.random(in: food.size.width/2 ... (size.width - food.size.width/2))
        
        food.position = CGPoint(x: actualX, y: size.height + food.size.height/2)
        
        addChild(food)
        
        let actualDuration = Float.random(in: 2.0 ... 4.0)
        
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -food.size.height/2), duration:
            TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        let loseAction = SKAction.run() { [weak self] in
            guard let `self` = self else {return}
            self.lostFood(food: food)
        }
        food.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
    }
    
    func characterDidCollideWithFood(character: SKSpriteNode, food: SKSpriteNode) {
        // if your mouth is open to "catch" the food
        if mouthIsOpen {
            // add eating food sound
            //        run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
            
            // Ate bad food - game over!
            if food.name == "pepper" {
                gameOver()
            }
            food.removeFromParent()
            foodEaten += 1
            scoreLabel.text = String(foodEaten)
        }
        // mouth isn't open - lost food
        else {
            lostFood(food: food)
        }
    }
    
    
    
    func gameOver() {
        let reveal = SKTransition.flipVertical(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size, score: foodEaten, characterType: self.theme)
        self.view?.presentScene(gameOverScene, transition: reveal)
    }
    
    func lostFood(food: SKSpriteNode) {
        // if you still have lives and lost food isn't "bad" food
        if lives > 0  && food.name != "pepper"{
            // decrease lives by one
            lives -= 1
            
            // update the "life counter"
            if let lifeLabelText = self.lifeLabel.text {
                self.lifeLabel.text = lifeLabelText + "X"
            }
            else {
                self.lifeLabel.text = "X"
            }
        }
        // if you don't have any lives left
        else {
            // if lost lost food isn't "bad" food
            if food.name != "pepper" {
                // game over
                gameOver()
            }
        }
    }

    // function to "drag" the character across the screen
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if (touchedNode.name == "character") {
            let xPos = touchLocation.x
            // move the character's xPos but its yPos stays constant
            character.position = CGPoint(x: xPos, y: size.height * 0.2)
        }
    }
    
//    func checkMouthPosition() {
//        if mouthIsOpen {
//            character.texture = SKTexture(imageNamed: "tester-open")
//        }
//        else {
//            character.texture = SKTexture(imageNamed: "tester-close")
//        }
//    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.food != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.character != 0)) {
            if let food = firstBody.node as? SKSpriteNode,
                let character = secondBody.node as? SKSpriteNode {
                characterDidCollideWithFood(character: character, food: food)
            }
        }
    }

}

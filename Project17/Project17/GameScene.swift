//
//  GameScene.swift
//  Project17
//
//  Created by Karen Lima on 21/09/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    //used for effects
    var starField: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var possibleEnemies = ["ball", "hammer", "tv"]
    var gameTimer: Timer?
    var isGameOver = false
    
    var intervalTime = 1.0
    
    var numberOfEnemies = 0
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starField = SKEmitterNode(fileNamed: "starfield")!
        starField.position = CGPoint(x: 1024, y: 384)
        //create 10s and move 10s
        starField.advanceSimulationTime(10)
        addChild(starField)
        //behind all
        starField.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        //create phisicsbody from a texture, a picture inside
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        //for collisions
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        gameTimer = Timer.scheduledTimer(timeInterval: intervalTime, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
        
        
    }
    @objc func createEnemy(){
        //challenge 3 - day 63
        if !isGameOver {
            guard let enemy = possibleEnemies.randomElement() else { return }
            let sprite = SKSpriteNode(imageNamed: enemy)
            sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
            addChild(sprite)
            
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
            //colide with player
            sprite.physicsBody?.categoryBitMask = 1
            //moving very hard to left
            sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
            //constant spin, spint to the air while moving
            sprite.physicsBody?.angularVelocity = 5
            //constrols how fast things slow down. here will never slow downs
            sprite.physicsBody?.linearDamping = 0
            //how is the spinning. will never stop living
            sprite.physicsBody?.angularDamping = 0
            
            numberOfEnemies += 1
        }
        
        if numberOfEnemies == 20 {
            gameTimer?.invalidate()
            if intervalTime > 0{
                intervalTime -= 0.1
            }
            gameTimer = Timer.scheduledTimer(timeInterval: intervalTime, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
            numberOfEnemies = 0
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        if !isGameOver{
            score += 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)

        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }

        player.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if children.contains(player) {
            eliminatePlayer()
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        eliminatePlayer()
    }
    
    func eliminatePlayer() {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        isGameOver = true
    }
}

//
//  GameScene.swift
//  Milestone-16-18
//
//  Created by Karen Lima on 25/09/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var gameTimer: Timer?
    var intervalTime = 1.0
    var possibleYPositions = [280, 480, 680]

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "bg_wood")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 980, y: 700)
        scoreLabel.horizontalAlignmentMode = .right
        addChild(scoreLabel)
        
        createLine(at: CGPoint(x: 512, y: 584), zPosition: CGFloat(1))
        createLine(at: CGPoint(x: 512, y: 384), zPosition: CGFloat(1))
        createLine(at: CGPoint(x: 512, y: 184), zPosition: CGFloat(1))
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        gameTimer = Timer.scheduledTimer(timeInterval: intervalTime, target: self, selector: #selector(createTarget), userInfo: nil, repeats: true)
        
    }
    @objc func createTarget(){
//        let target = Star()
        let xScale = 100
        let yScale = 100
        
        guard let yposition = possibleYPositions.randomElement() else { return }
        let sprite = SKSpriteNode(imageNamed: "star")
        sprite.name = "star"
        //target.configure(at: CGPoint(x: 1200, y: yposition), xScale: CGFloat(xScale), yScale: CGFloat(yScale))
        //print(sprite.size)
        sprite.scale(to: CGSize(width: xScale, height: yScale))
//        sprite.xScale = CGFloat(xScale)
//        sprite.yScale = CGFloat(yScale)
        sprite.position = CGPoint(x: 1200, y: yposition)
        addChild(sprite)
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 0
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        //sprite.run(SKAction.move(by: CGVector(dx: -500, dy: 0), duration: 10))
        //addChild(sprite)
    }
    
    func createLine(at position: CGPoint, zPosition: CGFloat) {
        let line = SKSpriteNode(imageNamed: "line")
        line.position = position
        line.zPosition = zPosition
        line.scale(to: CGSize(width: CGFloat(1024), height: CGFloat(100)))
        addChild(line)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        var tappedStar = false
        let tappedNodes = nodes(at: location)
   
        for node in tappedNodes {
            if node.name == "star"{
                node.removeFromParent()
                score += 100
                tappedStar = true
            }
        }
        if tappedStar == false {
            score -= 1000
        }
    }
    
//    func didBegin(_ contact: SKPhysicsContact) {
//        let explosion = SKEmitterNode(fileNamed: "explosion")!
//        if let position = contact.bodyA.node?.position {
//            explosion.position = position
//            addChild(explosion)
//        } else {
//            if let position = contact.bodyB.node?.position {
//                explosion.position = position
//                addChild(explosion)
//        }
//
//        }
//    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

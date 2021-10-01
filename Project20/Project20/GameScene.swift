//
//  GameScene.swift
//  Project20
//
//  Created by Karen Lima on 29/09/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    
    var leftEdge = -22
    var bottomEdge = -22
    let rightEdge = 1024 + 22
    
    var isGameOver = false
    var gameFinalScore: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var numberOfLaunches = 0
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 1000, y: 710)
        addChild(scoreLabel)
        
        gameTimer = Timer()
        gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int){
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let fireWork = SKSpriteNode(imageNamed: "rocket")
        fireWork.colorBlendFactor = 1
        fireWork.name = "firework"
        node.addChild(fireWork)
        
        switch Int.random(in: 0...2){
        case 0:
            fireWork.color = .cyan
        case 1:
            fireWork.color = .green
        default:
            fireWork.color = .red
        }
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse"){
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        fireworks.append(node)
        addChild(node)
        
    }
    
    @objc func launchFireworks() {
        if numberOfLaunches > 5 {
            gameOver()
            return
        }
        let movementAmount: CGFloat = 1800
        switch Int.random(in: 0...3){
        case 0:
            //fire five, straight up
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
            
        case 1:
            //fire five in a fan
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
        case 2:
            //fire five, from left to the right
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
        case 3:
            //fire five, from the right to the left
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
        default:
            break
        }
        numberOfLaunches += 1
    }
    func gameOver() {
        gameTimer?.invalidate()
        isGameOver = true
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.zPosition = 1
        addChild(gameOver)
        
        gameFinalScore = SKLabelNode(fontNamed: "Chalkduster")
        gameFinalScore.text = "Final score: \(score)"
        gameFinalScore.position = CGPoint(x: 512, y: 300)
        gameFinalScore.fontSize = 48
        gameFinalScore.zPosition = 1
        addChild(gameFinalScore)
        
        scoreLabel.removeFromParent()
    }
    
    func checkTouches(_ touches: Set<UITouch>){
        if isGameOver {
            return
        }
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { return }
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                } 
            }
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    override func update(_ currentTime: TimeInterval) {
        
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
                
            }
        }
    }
    
    func explode(firework: SKNode) {
        if isGameOver {
            return
        }
        if let emitter = SKEmitterNode(fileNamed: "explode"){
            emitter.position = firework.position
            addChild(emitter)
            let otherWait = SKAction.wait(forDuration: 5)
            //SKAction.
            let otherSequence = SKAction.sequence([otherWait, SKAction.removeFromParent()])
            run(otherSequence)
            //assert(emitter.position.y == nil, "were not removed")
            //emitter.removeFromParent()
        }
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        if isGameOver {
            return
        }
        var numExploded = 0
        for (index, fireworkContainer) in fireworks.enumerated().reversed(){
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { return }
            
            if firework.name == "selected"{
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        
        switch numExploded {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
}

//
//  GameScene.swift
//  Project11
//
//  Created by Karen Lima on 04/09/21.
//

import SpriteKit
class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    var editingMode: Bool = false {
        didSet{
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    var ballsLabel: SKLabelNode!
    var remainingBalls = 5 {
        didSet{
            ballsLabel.text = "Balls: \(remainingBalls)"
        }
    }
    let ballNames = ["ballRed", "ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballYellow"]
    
    var boxes = 0

    var startingGame = true
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        ballsLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballsLabel.text = "Balls: \(remainingBalls)"
        ballsLabel.horizontalAlignmentMode = .right
        ballsLabel.position = CGPoint(x: 800, y: 700)
        addChild(ballsLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            //editingMode = !editingMode
            editingMode.toggle()
        } else {
            if editingMode {
                //creat a box
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                box.name = "box"
                boxes+=1
                addChild(box)
                startingGame = false
            } else{
                if boxes != 0 || startingGame == true {
                    if remainingBalls > 0 {
                        remainingBalls-=1
                        let ballName = ballNames.randomElement()!
                        let ball = SKSpriteNode(imageNamed: ballName)
                        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                        ball.physicsBody?.restitution = 0.4
                        //location.y = 0
                        //which node should i bump into
                        //which collisions you want to know about
                        //tell about the collisions that happen
                        //collisionBitMask determines what objects a node bounces off, and contactTestBitMask determines which collisions are reported to us.
                        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                        ball.position = location
                        ball.position.y = 768
                        ball.name = "ball"
                        addChild(ball)
                        //let box = SKSpriteNode(color: .red, size: CGSize(width: 64, height: 64))
                        //box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
                        //box.position = location
                        //addChild(box)
                    } else {
                        let ac = UIAlertController(title: "Game Over", message: "You achieved the limit of balls", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: restartGame))
                        self.view?.window?.rootViewController?.present(ac, animated: true)
                    }
                } else {
                    let ac = UIAlertController(title: "Well Done", message: "You removed all obstacles", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: restartGame))
                    self.view?.window?.rootViewController?.present(ac, animated: true)
                }
                
                
            }
           
        }
    }
    
    func restartGame(action: UIAlertAction){
        remainingBalls = 5
        score = 0
        startingGame = true
    }
    
    func makeBouncer(at position: CGPoint){
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        bouncer.zPosition = 1
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool){
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 1)
        let spinForver = SKAction.repeatForever(spin)
        slotGlow.run(spinForver)
    }
    
    func collision(between ball: SKNode, object: SKNode){
        if object.name == "good"{
            destroy(ball: ball)
            score+=1
            remainingBalls+=1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score-=1
        } else if object.name == "box" {
            boxes-=1
            object.removeFromParent()
        }
    }
    
    func destroy(ball: SKNode){
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles"){
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
}

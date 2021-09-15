//
//  GameScene.swift
//  Project14
//
//  Created by Karen Lima on 14/09/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var slots = [WhackSlot]()
    
    var gameScore: SKLabelNode!
    var gameFinalScore: SKLabelNode!
    var popoupTime = 0.85
    var numRounds = 0
    
    var score = 0{
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410))}
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320))}
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230))}
        for i in 0..<5 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140))}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            [unowned self] in
            self.createEnemy()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes{
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit {continue}
            whackSlot.hit()
            if node.name == "charFriend"{
                score -= 5
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            } else if node.name == "charEnemy" {
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
        
                score += 1
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        numRounds += 1
        if numRounds >= 10 {
            for slot in slots {
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
           
            gameFinalScore = SKLabelNode(fontNamed: "Chalkduster")
            gameFinalScore.text = "Final score: \(score)"
            gameFinalScore.horizontalAlignmentMode = .center
            gameFinalScore.fontSize = 48
            gameFinalScore.position = CGPoint(x: 512, y: 300)
            gameFinalScore.zPosition = 1
            addChild(gameFinalScore)
            run(SKAction.playSoundFileNamed("GameOver.mp3", waitForCompletion: false))
            return
        }
        popoupTime *= 0.991
        
        slots.shuffle()
        slots[0].show(hideTime: popoupTime)
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popoupTime)}
        if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: popoupTime)}
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popoupTime)}
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popoupTime)}
        
        let minDelay = popoupTime / 2.0
        let maxDelay = popoupTime * 2
        
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            [weak self] in
            self?.createEnemy()
        }
    }
}

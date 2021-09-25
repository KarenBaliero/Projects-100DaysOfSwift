//
//  Star.swift
//  Milestone-16-18
//
//  Created by Karen Lima on 25/09/21.
//

import SpriteKit
import UIKit

class Star: SKNode {
    static let stars = ["star"]
    
    func configure(at position: CGPoint, xScale: CGFloat, yScale: CGFloat) {
        self.position = position
        
        let stick = SKSpriteNode(imageNamed: "stick")
        stick.position = CGPoint(x: 0, y: 0)
        stick.zPosition = 0
        addChild(stick)
        
        let starPrefix = "star"
        let star = SKSpriteNode(imageNamed: starPrefix)
        star.zPosition = 2
        star.position = CGPoint(x: 0, y: 100)
        addChild(star)
        
        self.xScale = xScale
        self.yScale = yScale
    }
    
    
}

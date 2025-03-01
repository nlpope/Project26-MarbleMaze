//
//  GameScene+Ext.swift
//  Project26-MarbleMaze
//
//  Created by Noah Pope on 12/19/24.
//

import SpriteKit
import GameplayKit

extension GameScene
{
    func generateBackground()
    {
        let background                          = SKSpriteNode(imageNamed: ImageNames.background)
        background.position                     = CGPoint(x: 512, y: 384)
        background.blendMode                    = .replace
        background.zPosition                    = -1
        
        addChild(background)
    }
    
    func loadBlock(atPosition position: CGPoint)
    {
        let node                            = SKSpriteNode(imageNamed: ImageNames.block)
        node.position                       = position
        node.physicsBody                    = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask   = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic         = false
        
        addChild(node)
    }
    
    
    func loadVortex(atPosition posiiton: CGPoint)
    {
        let node                                = SKSpriteNode(imageNamed: ImageNames.vortex)
        node.name                               = NodeNames.vortex
        node.position                           = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody                        = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic             = false
        
        node.physicsBody?.categoryBitMask       = CollisionTypes.vortex.rawValue
        node.physicsBody?.contactTestBitMask    = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask      = 0
        
        addChild(node)
    }
    
    
    func loadStar(atPosition position: CGPoint)
    {
        let node                                = SKSpriteNode(imageNamed: ImageNames.star)
        node.name                               = NodeNames.star
        node.position                           = position
        node.physicsBody                        = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic             = false
        
        node.physicsBody?.categoryBitMask       = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask    = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask      = 0
        
        addChild(node)
    }
    
    
    func loadFinish(atPosition position: CGPoint)
    {
        let node                                = SKSpriteNode(imageNamed: ImageNames.finish)
        node.name                               = NodeNames.finish
        node.position                           = position
        node.physicsBody                        = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic             = false
        
        node.physicsBody?.categoryBitMask       = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask    = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask      = 0
        
        addChild(node)
    }
}

//
//  GameScene.swift
//  Project26-MarbleMaze
//
//  Created by Noah Pope on 12/14/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene
{
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView)
    {
        
    }
    
    
    func loadLevel()
    {
        guard let levelURL      = Bundle.main.url(forResource: "level1", withExtension: "txt")
        else { fatalError("Could not find level1.txt in the app bundle.") }
        
        guard let levelString   = try? String(contentsOf: levelURL)
        else { fatalError("Could not load level1.txt from app budnle.") }
        
        let lines               = levelString.components(separatedBy: "\n")
        for (row, line) in lines.reversed().enumerated()
        {
            for (column, letter) in line.enumerated()
            {
                let position    = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                #warning("change to switch cases?")
                if letter == "x"
                {
                    let node                            = SKSpriteNode(imageNamed: ImageNames.block)
                    
                    node.position                       = position
                    node.physicsBody                    = SKPhysicsBody(rectangleOf: node.size)
                    node.physicsBody?.categoryBitMask   = CollisionTypes.wall.rawValue
                    node.physicsBody?.isDynamic         = false
                    
                    addChild(node)
                }
                else if letter == "v"
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
                else if letter == "s" { /* load star */}
                else if letter == "f" { /* load finish */}
                else if letter == " " { /* empty space - do nothing */}
                else { fatalError("Unknown level letter: \(letter)") }
            }
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint)
    {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    
    func touchMoved(toPoint pos : CGPoint)
    {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    
    func touchUp(atPoint pos : CGPoint)
    {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        // Called before each frame is rendered
    }
}

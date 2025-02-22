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
        generateBackground()
        loadLevel()
    }
    
    
    // is this func causing red 'x's to appear?
    func loadLevel()
    {
        guard let levelURL      = Bundle.main.url(forResource: "level1", withExtension: "txt")
        else { fatalError("Could not find level1.txt in the app bundle.") }
        guard let levelString   = try? String(contentsOf: levelURL)
        else { fatalError("Could not load level1.txt from app budnle.") }
        
        let lines               = levelString.trimmingCharacters(in: .newlines).components(separatedBy: "\n")
        for (row, line) in lines.reversed().enumerated()
        {
            for (column, letter) in line.enumerated()
            {
                let position    = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                switch letter
                {
                case "x":
                    loadBlock(atPosition: position)
                case "v":
                    loadVortex(atPosition: position)
                case "s":
                    loadStar(atPosition: position)
                case "f":
                    loadFinish(atPosition: position)
                case " ":
                    break
                default:
                    fatalError("Unknown level letter: \(letter)")
                }
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

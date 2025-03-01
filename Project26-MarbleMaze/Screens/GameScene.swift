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
    var player: SKSpriteNode!
    
    override func didMove(to view: SKView)
    {
        generateBackground()
        loadLevel()
    }
    
    
    func createPlayer()
    {
        // 1. load sprite
        player = SKSpriteNode(imageNamed: ImageNames.player)
        // 2. give it circle physics
        // 3. add it to the scene
        
        // 4. set phys body's allowrotation to false
        // 5. give ball linearDamping value of 0.5
        // 6. combine star, vortex and finish line values to get ball's contactTestBitMask
    }
    
    
    // is this func causing red 'x's to appear?
    func loadLevel()
    {
        guard let levelURL      = Bundle.main.url(forResource: "level1", withExtension: "txt")
        else { fatalError("Could not find level1.txt in the app bundle.") }
        guard let levelString   = try? String(contentsOf: levelURL, encoding: .macOSRoman)
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
       
    }
    
    
    func touchMoved(toPoint pos : CGPoint)
    {
       
    }
    
    
    func touchUp(atPoint pos : CGPoint)
    {
       
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
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

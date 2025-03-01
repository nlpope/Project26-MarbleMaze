//
//  GameScene.swift
//  Project26-MarbleMaze
//
//  Created by Noah Pope on 12/14/24.
//

import CoreMotion
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var motionManager: CMMotionManager!
    
    var scoreLabel: SKLabelNode!
    var score       = 0 { didSet { scoreLabel.text = "Score: \(score)" } }
    var isGameOver  = false
    
    override func didMove(to view: SKView)
    {
        generateBackground()
        loadLevel()
        generateLabels()
        createPlayer()
        setUpMotionManager()
        setUpPhysicsWorld()
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
    
    
    func setUpMotionManager()
    {
        motionManager   = CMMotionManager()
        motionManager.startAccelerometerUpdates()
    }
    
    
    func setUpPhysicsWorld()
    {
        physicsWorld.gravity            = .zero
        physicsWorld.contactDelegate    = self
    }
    
    
    func playerCollided(with node: SKNode)
    {
        if node.name == NodeNames.vortex
        {
            player.physicsBody?.isDynamic   = false
            isGameOver                      = true
            score -= 1
            
            let move        = SKAction.move(to: node.position, duration: 0.25)
            let scale       = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove      = SKAction.removeFromParent()
            let sequence    = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                guard let self  = self else { return }
                
                self.createPlayer()
                self.isGameOver = false
            }
        }
        
        else if node.name == NodeNames.star
        {
            score += 1
            
            let scale       = SKAction.scale(to: 3.0, duration: 0.25)
            let fade        = SKAction.fadeOut(withDuration: 0.35)
            let remove      = SKAction.removeFromParent()
            let sequence    = SKAction.sequence([scale, fade, remove])
            
            player.run(sequence)
        }
        
        else if node.name == NodeNames.finish
        {
            isGameOver = true
        }
    }
    
    //-------------------------------------//
    // MARK: TOUCH METHODS
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player { playerCollided(with: nodeB) }
        else if nodeB == player { playerCollided(with: nodeA) }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch     = touches.first else { return }
        let location        = touch.location(in: self)
        lastTouchPosition   = location
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch     = touches.first else { return }
        let location        = touch.location(in: self)
        lastTouchPosition   = location
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { lastTouchPosition = nil }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        guard !isGameOver else { return }
        
        /* COMPILER DIRECTIVES */
        #if targetEnvironment(simulator)
        if let currentTouch = lastTouchPosition
        {
            let diff                = CGPoint(x: currentTouch.x - player.position.x,
                                              y: currentTouch.y - player.position.y)
            physicsWorld.gravity    = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData    = motionManager.accelerometerData
        {
            physicsWorld.gravity    = CGVector(dx: accelerometerData.acceleration.y * -50,
                                               dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
}

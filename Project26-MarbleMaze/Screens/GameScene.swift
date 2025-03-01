//
//  GameScene.swift
//  Project26-MarbleMaze
//
//  Created by Noah Pope on 12/14/24.
//

import CoreMotion
import SpriteKit
import GameplayKit

class GameScene: SKScene
{
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var motionManager: CMMotionManager!
    
    override func didMove(to view: SKView)
    {
        generateBackground()
        loadLevel()
        createPlayer()
        setUpMotionManager()
    }
    
    
    // is this func causing red 'x's to appear?
    func loadLevel()
    {
        physicsWorld.gravity    = .zero
        
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
    
    
    func createPlayer()
    {
        player                                  = SKSpriteNode(imageNamed: ImageNames.player)
        player.position                         = CGPoint(x: 96, y: 672)
        player.zPosition                        = 1
        player.physicsBody                      = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation      = false
        player.physicsBody?.linearDamping       = 0.5
        
        player.physicsBody?.categoryBitMask     = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask  = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask    = CollisionTypes.wall.rawValue
        
        addChild(player)
    }
    
    
    func setUpMotionManager()
    {
        motionManager   = CMMotionManager()
        motionManager.startAccelerometerUpdates()
    }
    
    //-------------------------------------//
    // MARK: TOUCH METHODS
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
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { lastTouchPosition   = nil }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        // COMPILER DIRECTIVES
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

//
//  PlayerPlane.swift
//  WarFly
//
//  Created by dmitrii on 01.06.19.
//  Copyright © 2019 dmitrii. All rights reserved.
//
import CoreMotion
import SpriteKit

class PlayerPlane: SKSpriteNode {
    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0
    let screensize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    var leftTextureArrayAnimation = [SKTexture]()
    var rightTextureArrayAnimation = [SKTexture]()
    var forwardTextureArrayAnimation = [SKTexture]()
    var moveDirection: TurnDirection = .none
    var stillTurning: Bool = false
    let animationSpriteStrides = [(13, 1, -1), (13,26,1), (13,13,1)]

    
    static func populate(at point: CGPoint) -> PlayerPlane {
        let atlas = Assets.share.playerPlaneAtlas
        let playerPlaneTexture = atlas.textureNamed("airplane_3ver2_13.png")
        
        let playerPlane = PlayerPlane(texture: playerPlaneTexture)
        playerPlane.setScale(0.5)
        playerPlane.position = point
        playerPlane.zPosition = 40
        
        let offsetX = playerPlane.frame.size.width * playerPlane.anchorPoint.x
        let offsetY = playerPlane.frame.size.height * playerPlane.anchorPoint.y
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 9 - offsetX, y: 76 - offsetY))
        path.addLine(to: CGPoint(x: 65 - offsetX, y: 87 - offsetY))
        path.addLine(to: CGPoint(x: 70 - offsetX, y: 98 - offsetY))
        path.addLine(to: CGPoint(x: 78 - offsetX, y: 99 - offsetY))
        path.addLine(to: CGPoint(x: 140 - offsetX, y: 76 - offsetY))
        path.addLine(to: CGPoint(x: 142 - offsetX, y: 66 - offsetY))
        path.addLine(to: CGPoint(x: 86 - offsetX, y: 55 - offsetY))
        path.addLine(to: CGPoint(x: 80 - offsetX, y: 25 - offsetY))
        path.addLine(to: CGPoint(x: 95 - offsetX, y: 11 - offsetY))
        path.addLine(to: CGPoint(x: 59 - offsetX, y: 6 - offsetY))
        path.addLine(to: CGPoint(x: 70 - offsetX, y: 26 - offsetY))
        path.addLine(to: CGPoint(x: 66 - offsetX, y: 58 - offsetY))
        path.addLine(to: CGPoint(x: 10 - offsetX, y: 64 - offsetY))
        path.closeSubpath()

        playerPlane.physicsBody = SKPhysicsBody(polygonFrom: path)
        playerPlane.physicsBody?.isDynamic = false
        playerPlane.physicsBody?.categoryBitMask = BitMaskCategory.player.rawValue
        playerPlane.physicsBody?.collisionBitMask = BitMaskCategory.enemy.rawValue | BitMaskCategory.powerUp.rawValue
        playerPlane.physicsBody?.contactTestBitMask = BitMaskCategory.enemy.rawValue | BitMaskCategory.powerUp.rawValue
        return playerPlane
    }
    
    func checkPosition() {
        self.position.x += xAcceleration * 50
        if self.position.x < -70 {
            self.position.x = screensize.width + 70
        } else if self.position.x > screensize.width + 70 {
            self.position.x = -70
        }
    }
    
    func performFly() {
        preloadTextureArrays()
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { [unowned self] (data, error) in
            if let data = data {
                let accelaration = data.acceleration
                self.xAcceleration = CGFloat(accelaration.x) * 0.7 + self.xAcceleration * 0.3
            }
        }
        
        let planeWaitAction = SKAction.wait(forDuration: 1.0)
        let planeDirectionCheckAction = SKAction.run { [unowned self] in
            self.movementDirectionCheck()
        }
        let planeSequence = SKAction.sequence([planeWaitAction, planeDirectionCheckAction])
        let planeSequenceForever = SKAction.repeatForever(planeSequence)
        self.run(planeSequenceForever)
    }
    
    fileprivate func preloadArray(_stride: (Int, Int, Int), callback: @escaping(_ array: [SKTexture]) -> ()) {
        var array = [SKTexture]()
        for i in stride(from: _stride.0, through: _stride.1, by: _stride.2) {
            let number = String(format: "%02d", i)
            let texture = SKTexture(imageNamed: "airplane_3ver2_\(number)")
            array.append(texture)
        }
        
        SKTexture.preload(array) {
            callback(array)
        }
    }
    
    fileprivate func preloadTextureArrays() {
        for i in 0...2 {
            self.preloadArray(_stride: animationSpriteStrides[i], callback: { [unowned self] array in
                switch i  {
                case 0: self.leftTextureArrayAnimation = array
                case 1: self.rightTextureArrayAnimation = array
                case 2: self.forwardTextureArrayAnimation = array
                default: break
                }
            })
        }
    }
    


    fileprivate func movementDirectionCheck() {
        if xAcceleration > 0.05, moveDirection != .right, stillTurning == false {
            stillTurning = true
            moveDirection = .right
            turnPlane(direction: .right)
        } else if xAcceleration < -0.05, moveDirection != .left, stillTurning == false {
            stillTurning = true
            moveDirection = .left
            turnPlane(direction: .left)

        } else if stillTurning == false {
            turnPlane(direction: .none)

        }
    }

    fileprivate func turnPlane(direction: TurnDirection) {
        var array = [SKTexture]()

        if direction == .right {
            array = rightTextureArrayAnimation
        } else if direction == .left {
            array = leftTextureArrayAnimation
        } else if direction == .none {
            array = forwardTextureArrayAnimation
        }

        let forwardAction = SKAction.animate(with: array, timePerFrame: 0.05, resize: true, restore: false)
        let backwardAction = SKAction.animate(with: array.reversed(), timePerFrame: 0.05, resize: true, restore: false)
        let sequenceAction = SKAction.sequence([forwardAction, backwardAction])
        self.run(sequenceAction) { [unowned self] in
            self.stillTurning = false
        }
    }
}



enum TurnDirection {
    case left
    case right
    case none
}

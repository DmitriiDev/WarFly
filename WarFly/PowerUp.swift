//
//  PowerUp.swift
//  WarFly
//
//  Created by dmitrii on 02.06.19.
//  Copyright © 2019 dmitrii. All rights reserved.
//

import SpriteKit

class PowerUp: SKSpriteNode {
    fileprivate  let initialSize = CGSize(width: 52, height: 52)
    fileprivate  let textureAtlas: SKTextureAtlas!
    fileprivate var animationSpriteArray = [SKTexture]()
    fileprivate  var textureNameBeignsWith = ""
    
    init(textureAtlas: SKTextureAtlas) {
        self.textureAtlas = textureAtlas
        let nameTexture = textureAtlas.textureNames.sorted()[0]
        let texture = textureAtlas.textureNamed(nameTexture)
        self.textureNameBeignsWith = String(nameTexture.dropLast(6))
        super.init(texture: texture, color: .clear, size: initialSize)
        self.name = "sprite"
        self.setScale(0.7)
        self.zPosition = 20
        self.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.5, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = BitMaskCategory.powerUp.rawValue
        self.physicsBody?.collisionBitMask = BitMaskCategory.player.rawValue
        self.physicsBody?.contactTestBitMask = BitMaskCategory.player.rawValue
    }
    
    func startMovement() {
        performRotation()
        let moveForward = SKAction.moveTo(y: -100, duration: 5)
        self.run(moveForward)
    }
    
    fileprivate func performRotation() {
        for i in 1...15 {
            let number = String(format: "%02d", i)
            animationSpriteArray.append(SKTexture(imageNamed: textureNameBeignsWith + number.description))
        }
        
        SKTexture.preload(animationSpriteArray) {
            let rotation = SKAction.animate(with: self.animationSpriteArray, timePerFrame: 0.05, resize: true, restore: false)
            let rotationForever = SKAction.repeatForever(rotation)
            self.run(rotationForever)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

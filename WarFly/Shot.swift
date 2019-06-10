//
//  Shot.swift
//  WarFly
//
//  Created by dmitrii on 10.06.19.
//  Copyright © 2019 dmitrii. All rights reserved.
//

import SpriteKit

class Shot: SKSpriteNode {
    let screenSize = UIScreen.main.bounds
    fileprivate  let initialSize = CGSize(width: 187, height: 237)
    fileprivate  let textureAtlas: SKTextureAtlas!
    fileprivate var animationSpriteArray = [SKTexture]()
    fileprivate  var textureNameBeignsWith = ""
    
    init(textureAtlas: SKTextureAtlas) {
        self.textureAtlas = textureAtlas
        let nameTexture = textureAtlas.textureNames.sorted()[0]
        let texture = textureAtlas.textureNamed(nameTexture)
        self.textureNameBeignsWith = String(nameTexture.dropLast(6))
        super.init(texture: texture, color: .clear, size: initialSize)
        self.name = "shotSprite"
        self.setScale(0.7)
        self.zPosition = 30
    }
    
    func startMovement() {
        performRotation()
        let moveForward = SKAction.moveTo(y: screenSize.height + 100, duration: 2)
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

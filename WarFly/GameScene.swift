//
//  GameScene.swift
//  WarFly
//
//  Created by dmitrii on 01.06.19.
//  Copyright © 2019 dmitrii. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var player: PlayerPlane!
    override func didMove(to view: SKView) {
        configureStartScene()
        spawnClouds()
        spawnIsland()
        let deadline = DispatchTime.now() + .nanoseconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadline) { [unowned self] in 
            self.player.performFly()
        }
        
        spawnSpiralPowerUp()
        spawnEnemies()
        
    }
    
    fileprivate func spawnEnemies() {
        let waitAction = SKAction.wait(forDuration: 3.0)
        let spawnSpiralAction = SKAction.run { [unowned self] in
            self.spawnsSpiralOfEnemy()
        }
        self.run(SKAction.repeatForever(SKAction.sequence([waitAction, spawnSpiralAction])))
    }
    
    fileprivate func spawnsSpiralOfEnemy() {
        let enemyTextureAtlas1 = SKTextureAtlas(named: "Enemy_1")
        let enemyTextureAtlas2 = SKTextureAtlas(named: "Enemy_2")
        SKTextureAtlas.preloadTextureAtlases([enemyTextureAtlas1, enemyTextureAtlas2]) { [unowned self] in
            let randomNum = Int(arc4random_uniform(2))
            let arrayOfAtlases = [enemyTextureAtlas1,enemyTextureAtlas2]
            let textureAtlas = arrayOfAtlases[randomNum]
            let waitAction = SKAction.wait(forDuration: 1.0)
            let spawnEnemy = SKAction.run({
                let textureNames = textureAtlas.textureNames.sorted()
                let texture = textureAtlas.textureNamed(textureNames[12])
                let enemy = Enemy(enemyTexture: texture)
                enemy.position = CGPoint(x: self.size.width / 2, y: self.size.height + 110)
                self.addChild(enemy)
                enemy.flySpiral()
            })
            
            let spawnAction = SKAction.sequence([spawnEnemy, waitAction])
            let repeatSpawnEnemy = SKAction.repeat(spawnAction, count: 3)
            self.run(repeatSpawnEnemy)
        }
    }
    
    
    fileprivate func spawnSpiralPowerUp() {
        let powerUp = PowerUp()
        powerUp.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        powerUp.performRotation()
        self.addChild(powerUp)
        
    }
    
    fileprivate func spawnClouds() {
        let spawnCloudWait = SKAction.wait(forDuration: 3)
        let spawnCloudAction = SKAction.run {
            let cloud = Cloud.populate(at: nil)
            self.addChild(cloud)
        }
        
        let spawnCloudSequence = SKAction.sequence([spawnCloudWait,spawnCloudAction])
        let spawnCloudForever = SKAction.repeatForever(spawnCloudSequence)
        run(spawnCloudForever)
    }
    
    fileprivate func spawnIsland() {
        let spawnIslandWait = SKAction.wait(forDuration: 3)
        let spawnIslandAction = SKAction.run {
            let island = Island.populate(at: nil)
            self.addChild(island)
        }
        
        let spawnIslandSequence = SKAction.sequence([spawnIslandWait,spawnIslandAction])
        let spawnIslandForever = SKAction.repeatForever(spawnIslandSequence)
        run(spawnIslandForever)
    }
    
    
    fileprivate func configureStartScene() {
        let screenCenterPoint = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        let background = Background.populateBackground(at: screenCenterPoint)
        self.addChild(background)
        let screen = UIScreen.main.bounds
        
        let island2 = Island.populate(at: CGPoint(x: self.size.width - 100, y: self.size.height - 200))
        self.addChild(island2)
        
        let cloud = Cloud.populate(at: nil)
        self.addChild(cloud)
        
        player = PlayerPlane.populate(at: CGPoint(x: screen.size.width / 2, y: 100))
        self.addChild(player)
        
    }
    override func didSimulatePhysics() {
        enumerateChildNodes(withName: "sprite") { (node, stop) in
            if node.position.y < -100  {
                node.removeFromParent()
            }
        }
    }
    
}










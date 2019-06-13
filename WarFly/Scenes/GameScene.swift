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
    let hud = HUD()
    let screenSize = UIScreen.main.bounds.size

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        configureStartScene()
        spawnClouds()
        spawnIsland()
        createHUD()
        
        // пример использования DispatchQueue
//        let deadline = DispatchTime.now() + .nanoseconds(1)
//        DispatchQueue.main.asyncAfter(deadline: deadline) { [unowned self] in
//        }
        self.player.performFly()
        spawnSpiralPowerUp()
        spawnEnemies()
    }
    
   
    fileprivate func createHUD() {
        hud.configureUI(screenSize: screenSize)
        addChild(hud)
    }
    
    fileprivate func spawnEnemies() {
        let waitAction = SKAction.wait(forDuration: 3.0)
        let spawnSpiralAction = SKAction.run { [unowned self] in
            self.spawnsSpiralOfEnemy()
        }
        self.run(SKAction.repeatForever(SKAction.sequence([waitAction, spawnSpiralAction])))
    }
    
    fileprivate func spawnsSpiralOfEnemy() {
        let enemyTextureAtlas1 = Assets.share.enemy_1Atlas //(named: "Enemy_1")
        let enemyTextureAtlas2 = Assets.share.enemy_2Atlas // SKTextureAtlas(named: "Enemy_2")
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
        let powerUp = BluePowerUP()
        powerUp.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        
        let spawnAction = SKAction.run {
            let randomNumber = Int(arc4random_uniform(2))
            let powerUp = randomNumber == 1 ? BluePowerUP() : GreenPowerUP()
            let randomPositionX = arc4random_uniform(UInt32(UInt(self.size.width - 30)))
            powerUp.position = CGPoint(x: CGFloat(randomPositionX), y: self.size.height + 100)
            powerUp.startMovement()
            self.addChild(powerUp)
        }
        
        let randomTimeSpawn = Double(arc4random_uniform(11) + 10)
        let waitAction = SKAction.wait(forDuration: randomTimeSpawn)
        self.run(SKAction.repeatForever(SKAction.sequence([spawnAction, waitAction])))
        
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
            if node.position.y <= -50  {
                node.removeFromParent()
              
            }
        }
        
        enumerateChildNodes(withName: "shotSprite") { (node, stop) in
            if node.position.y >= self.size.height + 100  {
                node.removeFromParent()
            }
        }
    }
    
    fileprivate func playerFire() {
        let shot = YellowShot()
        shot.position = self.player.position
        shot.startMovement()
        self.addChild(shot)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "pause"  {
            let transition = SKTransition.doorway(withDuration: 1.0)
            let pauseScene = PauseScene(size: self.size)
            pauseScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(pauseScene, transition: transition)
        } else {
            playerFire()
        }
        
    }
    
}


extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contactCategory: BitMaskCategory = [contact.bodyA.category, contact.bodyB.category]
        
        switch contactCategory {
        case [.enemy, .player]: print("enemy vs player")
        case [.powerUp, .player]: print("powerUp vs player")
        case [.enemy, .shot]: print("enemy vs shot")
        default: preconditionFailure("Unable to detect collision category")
        }
        
//
//        let bodyA = contact.bodyA.categoryBitMask
//        let bodyB = contact.bodyB.categoryBitMask
//        let player = BitMaskCategory.player
//        let enemy = BitMaskCategory.enemy
//        let shot = BitMaskCategory.shot
//        let powerUp = BitMaskCategory.powerUp
//
//
//        if bodyA == player && bodyB == enemy || bodyA == enemy && bodyB == player {
//            print("enemy vs player")
//        } else if bodyA == player && bodyB == powerUp || bodyA == powerUp && bodyB == player {
//            print("player vs powerUp")
//        } else if bodyA == shot && bodyB == enemy || bodyA == enemy && bodyB == shot {
//            print("enemy vs shot")
//        }

    }
    
    func didEnd(_ contact: SKPhysicsContact) {
    }
    
}







//
//  GameScene.swift
//  WarFly
//
//  Created by dmitrii on 01.06.19.
//  Copyright © 2019 dmitrii. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: ParentScene {
    
    var backgroundMusic: SKAudioNode!
    let vibroGeneratorPlayerDamage = UIImpactFeedbackGenerator(style: .heavy)
    let vibroGeneratorEnemyDamage = UIImpactFeedbackGenerator(style: .medium)

    var player: PlayerPlane!
    let hud = HUD()
    let screenSize = UIScreen.main.bounds.size
    fileprivate var lives = 3 {
        didSet {
            switch lives {
            case 3:
                hud.life1.isHidden = false
                hud.life2.isHidden = false
                hud.life3.isHidden = false
            case 2:
                hud.life1.isHidden = false
                hud.life2.isHidden = false
                hud.life3.isHidden = true
            case 1:
                hud.life1.isHidden = false
                hud.life2.isHidden = true
                hud.life3.isHidden = true
            default:
                break
            }
        }
    }
    
    override func didMove(to view: SKView) {
        gameSettings.loadGameSettings()

        if let musicURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "m4a") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(self.backgroundMusic)
        }
        
        self.scene?.isPaused = false
        guard sceneManager.gameScene == nil else {
            return
        }
        sceneManager.gameScene = self
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
    
//
//    fileprivate func spaMusic() {
//        let spawnCloudWait = SKAction.wait(forDuration: 1)
//        let spawnCloudAction = SKAction.run {
//            if let musicURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "m4a") {
//                self.backgroundMusic = SKAudioNode(url: musicURL)
//                self.addChild(self.backgroundMusic)
//            }
//        }
//
//        let spawnCloudSequence = SKAction.sequence([spawnCloudWait, spawnCloudAction])
//        let spawnCloudForever = SKAction.repeatForever(spawnCloudSequence)
//        run(spawnCloudForever)
//    }
    
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
        player.checkPosition()
        enumerateChildNodes(withName: "sprite") { (node, stop) in
            if node.position.y <= -100  {
                node.removeFromParent()
                
            }
        }
        
        enumerateChildNodes(withName: "greenPowerUp") { (node, stop) in
            if node.position.y <= -100  {
                node.removeFromParent()
            }
        }
        
        enumerateChildNodes(withName: "bluePowerUp") { (node, stop) in
            if node.position.y <= -100  {
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
            sceneManager.gameScene = self
            self.scene?.isPaused = true
            self.scene!.view?.presentScene(pauseScene, transition: transition)
        } else {
            
            if hud.shotCount > 0 {
                playerFire()
                hud.shotCount -= 1
            }
        }
        
    }
    
}


extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "enemyExposion")
        explosion?.zPosition = 25
        let contactPoint = contact.contactPoint
        explosion?.position = contactPoint
        let waitForExplosionAction = SKAction.wait(forDuration: 1.0)
        let contactCategory: BitMaskCategory = [contact.bodyA.category, contact.bodyB.category]
        
        switch contactCategory {
        case [.enemy, .player]: print("enemy vs player")
        if contact.bodyA.node?.name == "sprite" {
            if contact.bodyA.node?.parent != nil {
                contact.bodyA.node?.removeFromParent()
                lives -= 1
                vibroGeneratorPlayerDamage.impactOccurred()

            }
        } else {
            if contact.bodyB.node?.parent != nil {
                contact.bodyB.node?.removeFromParent()
                lives -= 1
                vibroGeneratorPlayerDamage.impactOccurred()

            }
        }
        
        if lives == 0 {
            gameSettings.currentScore = hud.score
            gameSettings.saveScores()
            let transition = SKTransition.doorsCloseVertical(withDuration: 1.0)
            let gameOverScene = GameOverScene(size: self.size)
            gameOverScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(gameOverScene, transition: transition)
        }
        addChild(explosion!)
        self.run(waitForExplosionAction) { explosion?.removeFromParent() }
        case [.powerUp, .player]:
        print("powerUp vs player")
        if contact.bodyA.node?.parent != nil && contact.bodyB.node?.parent != nil {
            if contact.bodyA.node?.name == "greenPowerUp" {
                contact.bodyA.node?.removeFromParent()
                lives += 1
                player.greenPowerUp()
            }  else if contact.bodyB.node?.name == "greenPowerUp" {
                    contact.bodyB.node?.removeFromParent()
                    lives += 1
                    player.greenPowerUp()
                }
            else if contact.bodyB.node?.name == "bluePowerUp" {
                contact.bodyB.node?.removeFromParent()
                hud.shotCount += 20
                player.bluePowerUp()
            }
            }
        case [.enemy, .shot]: print("enemy vs shot")
        
        if contact.bodyA.node?.parent != nil && contact.bodyB.node?.parent != nil {
            vibroGeneratorEnemyDamage.impactOccurred()
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            self.run(SKAction.playSoundFileNamed("hitSound", waitForCompletion: false))
            hud.score += 5
            addChild(explosion!)
            self.run(waitForExplosionAction) { explosion?.removeFromParent() }
            }
            
            
        default: preconditionFailure("Unable to detect collision category")
        }

    }
    
    func didEnd(_ contact: SKPhysicsContact) {
    }
    
}































//
//  Assets.swift
//  WarFly
//
//  Created by dmitrii on 10.06.19.
//  Copyright © 2019 dmitrii. All rights reserved.
//

import SpriteKit

class Assets: SKSpriteNode {
    
    static let share = Assets()
    let yellowShotAtlas = SKTextureAtlas(named: "YellowAmmo")
    let enemy_1Atlas = SKTextureAtlas(named: "Enemy_1")
    let enemy_2Atlas = SKTextureAtlas(named: "Enemy_2")
    let playerPlaneAtlas = SKTextureAtlas(named: "PlayerPlane")
    let bluePowerUpAtlas = SKTextureAtlas(named: "BluePowerUp")
    let greenPowerUpAtlas = SKTextureAtlas(named: "GreenPowerUp")
    
    
    func preloadAssets() {
        yellowShotAtlas.preload {
            print("yellowAmmo preloaded")
        }
        enemy_1Atlas.preload {
            print("enemy_1 preloaded")
        }
        enemy_2Atlas.preload {
            print("enemy_2 preloaded")
        }
        playerPlaneAtlas.preload {
            print("playerPlane preloaded")
        }
        bluePowerUpAtlas.preload {
            print("bluePowerUp preloaded")
        }
        greenPowerUpAtlas.preload {
            print("greenPowerUp preloaded")
        }
    }

}

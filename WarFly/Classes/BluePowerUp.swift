//
//  BluePowerUp.swift
//  WarFly
//
//  Created by dmitrii on 09.06.19.
//  Copyright © 2019 dmitrii. All rights reserved.
//

import SpriteKit

class BluePowerUP: PowerUp {
    init() {
        let textureAtlas = Assets.share.bluePowerUpAtlas
        super.init(textureAtlas: textureAtlas)
        name = "bluePowerUp"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

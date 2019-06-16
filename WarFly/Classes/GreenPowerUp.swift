//
//  GreenPowerUp.swift
//  WarFly
//
//  Created by dmitrii on 09.06.19.
//  Copyright © 2019 dmitrii. All rights reserved.
//

import SpriteKit

class GreenPowerUP: PowerUp {
    init() {
        let textureAtlas = Assets.share.greenPowerUpAtlas
        super.init(textureAtlas: textureAtlas)
        name = "greenPowerUp"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


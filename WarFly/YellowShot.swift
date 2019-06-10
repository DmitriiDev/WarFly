//
//  YellowShot.swift
//  WarFly
//
//  Created by dmitrii on 10.06.19.
//  Copyright © 2019 dmitrii. All rights reserved.
//

import SpriteKit

class YellowShot: Shot {
    init() {
        let textureAtlas = SKTextureAtlas(named: "YellowAmmo")
        super.init(textureAtlas: textureAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

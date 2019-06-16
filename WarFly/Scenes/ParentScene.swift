//
//  ParentScene.swift
//  WarFly
//
//  Created by dmitrii on 16.06.19.
//  Copyright © 2019 dmitrii. All rights reserved.
//

import SpriteKit

class ParentScene: SKScene {
    let sceneManager = SceneManager.shared
    var backScene: SKScene?
    
    func setHeader(withName name: String?, andbackGround background: String) {
        let header = ButtonNode(titled: name, backgroundName: background)
        header.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150)
       self.addChild(header)
    }
}

//
//  SceneManager.swift
//  WarFly
//
//  Created by dmitrii on 14.06.19.
//  Copyright © 2019 dmitrii. All rights reserved.
//

class SceneManager {
    static let shared = SceneManager()
    
    private init() {}
    
    var gameScene: GameScene?
}

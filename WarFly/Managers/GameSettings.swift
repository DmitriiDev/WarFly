//
//  GameSettings.swift
//  WarFly
//
//  Created by dmitrii on 16.06.19.
//  Copyright © 2019 dmitrii. All rights reserved.
//

import UIKit

class GameSettings: NSObject {
    
    let ud = UserDefaults.standard
    var isMusic = true
    var isSound = true
    
    var hightScore: [Int] = []
    var currentScore = 0
    let hightScoreKey = "hightscore"
    
    func saveScores() {
        hightScore.append(currentScore)
        hightScore = Array(hightScore.sorted { $0 > $1 }.prefix(3))
        ud.set(hightScore, forKey: hightScoreKey)
        ud.synchronize()
    }
    
    func loadScores() {
        guard ud.value(forKey: hightScoreKey) != nil  else {
            return
        }
        hightScore = ud.array(forKey: hightScoreKey) as! [Int]
    }
    
    
    
    let musicKey = "music"
    let soundKey = "sound"
    
    override init() {
        super.init()
        loadScores()
        loadGameSettings()
    }
    
    func saveGameSettings() {
        ud.set(isMusic, forKey: musicKey)
        ud.set(isSound, forKey: soundKey)
    }
    
    func loadGameSettings() {
        guard ud.value(forKey: musicKey) != nil && ud.value(forKey: soundKey) != nil else {
            return
        }
        
        isMusic = ud.bool(forKey: musicKey)
        isSound = ud.bool(forKey: soundKey)
    }
    
    
}

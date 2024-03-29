//
//  HUD.swift
//  WarFly
//
//  Created by dmitrii on 11.06.19.
//  Copyright © 2019 dmitrii. All rights reserved.
//

import SpriteKit

class HUD: SKNode {
    
    let shotCountBackGround = SKSpriteNode(imageNamed: "button_background")
    let shotCountLabel = SKLabelNode(text: "35")
    var shotCount: Int = 35 {
        didSet {
            shotCountLabel.text = shotCount.description
        }
    }
    
    let scoreBackground = SKSpriteNode(imageNamed: "scores")
    let scoreLabel = SKLabelNode(text: "0")
    var screenSize: CGSize?
    var score: Int = 0 {
        didSet {
            scoreLabel.text = score.description
        }
    }
    let menuButton = SKSpriteNode(imageNamed: "menu")
    let life1 = SKSpriteNode(imageNamed: "life")
    let life2 = SKSpriteNode(imageNamed: "life")
    let life3 = SKSpriteNode(imageNamed: "life")

    
     func configureUI(screenSize: CGSize) {
        self.screenSize = screenSize
        scoreBackground.position = CGPoint(x: scoreBackground.size.width, y: screenSize.height - scoreBackground.size.height / 2 - 25)
        scoreBackground.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        scoreBackground.zPosition = 99
        addChild(scoreBackground)
        
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: -10, y: 3)
        scoreLabel.zPosition = 100
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 30
        scoreBackground.addChild(scoreLabel)
        
        shotCountBackGround.position = CGPoint(x: scoreBackground.size.width, y: screenSize.height - scoreBackground.size.height / 2 - 25)
        shotCountBackGround.anchorPoint = CGPoint(x: -1, y: 0.4)
        shotCountBackGround.xScale = 0.5
        shotCountBackGround.yScale = 0.5
        shotCountBackGround.zPosition = 100
        addChild(shotCountBackGround)
        
        shotCountLabel.horizontalAlignmentMode = .right
        shotCountLabel.verticalAlignmentMode = .center
        shotCountLabel.position = CGPoint(x: 320, y: 3)
        shotCountLabel.zPosition = 100
        shotCountLabel.fontName = "AmericanTypewriter-Bold"
        shotCountLabel.fontSize = 60
        shotCountBackGround.addChild(shotCountLabel)
        
        menuButton.position = CGPoint(x: 20, y: 20)
        menuButton.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        menuButton.zPosition = 100
        menuButton.name = "pause"
        addChild(menuButton)
        let lifes = [life1, life2, life3]
        for (index, life) in lifes.enumerated() {
            life.position = CGPoint(x: screenSize.width - CGFloat(index + 1) * (life.size.width + 3), y: 20)
            life.zPosition = 100
            life.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            addChild(life)
        }
    }
}

//
//  PauseScene.swift
//  WarFly
//
//  Created by dmitrii on 14.06.19.
//  Copyright © 2019 dmitrii. All rights reserved.
//

import SpriteKit

class PauseScene: ParentScene {

    override func didMove(to view: SKView) {
    
        self.backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
        setHeader(withName: "pause", andbackGround: "header_background")
        
        let titles = ["restart" , "options", "resume"]
        
        for (index, title) in titles.enumerated() {
            let button = ButtonNode(titled: title, backgroundName: "button_background")
            button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(100 * index))
            button.name = title
            button.label.name = title
            addChild(button)
        }
        
    }
    override func update(_ currentTime: TimeInterval) {
        if let gameScene = sceneManager.gameScene {
            if !gameScene.isPaused {
                gameScene.isPaused = true
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "restart"  {
            
            let transition = SKTransition.crossFade(withDuration: 1.0)
            sceneManager.gameScene = nil
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
            
        } else if node.name == "options" {
            
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let optionScene = OptionScene(size: self.size)
            optionScene.backScene = self
            optionScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(optionScene, transition: transition)
            
        } else if node.name == "resume" {
            
            let transition = SKTransition.crossFade(withDuration: 1.0)
            guard let gameScene = sceneManager.gameScene else { return }
            gameScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
            
        }
    }
    
    
}

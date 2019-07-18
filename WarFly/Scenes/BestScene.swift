//
//  BestScene.swift
//  WarFly
//
//  Created by dmitrii on 16.06.19.
//  Copyright © 2019 dmitrii. All rights reserved.
//

import SpriteKit

class BestScene: ParentScene {
    
    var places: [Int]!
    override func didMove(to view: SKView) {
        gameSettings.loadScores()
        places = gameSettings.hightScore
        
        for (index, title) in places.enumerated() {
            let button = ButtonNode(titled: String(title), backgroundName: "button_background")
            button.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 70 - CGFloat(100 * index))
            addChild(button)
        }
        
        
        self.backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
        setHeader(withName: "best", andbackGround: "header_background")
        
        let back = ButtonNode(titled: "back", backgroundName: "button_background")
        back.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 250)
        back.name = "back"
        back.label.text = "back"
        addChild(back)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "back" {

            let transition = SKTransition.crossFade(withDuration: 1.0)
            guard let backScene = backScene else {return}
            backScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(backScene, transition: transition)
        }
        
    }
    
}

//
//  OptionScene.swift
//  WarFly
//
//  Created by dmitrii on 16.06.19.
//  Copyright © 2019 dmitrii. All rights reserved.
//

import SpriteKit
class OptionScene: ParentScene {
    
    var isMusic: Bool!
    var isSound: Bool!

    
    override func didMove(to view: SKView) {
        
        isMusic = gameSettings.isMusic
        isSound = gameSettings.isSound
        
        self.backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
        setHeader(withName: "options", andbackGround: "header_background")
        
        
        let backgroundMusic = isMusic == true ? "music" : "nomusic"
        let music = ButtonNode(titled: nil, backgroundName: backgroundMusic)
        music.position = CGPoint(x: self.frame.midX - 50, y: self.frame.midY)
        music.name = "music"
        music.label.isHidden = true
        addChild(music)
        
        let backgroundSound = isMusic == true ? "sound" : "nosound"

        let sound = ButtonNode(titled: nil, backgroundName: backgroundSound)
        sound.position = CGPoint(x: self.frame.midX + 50, y: self.frame.midY)
        sound.name = "sound"
        sound.label.isHidden = true
        addChild(sound)
        
        let back = ButtonNode(titled: "back", backgroundName: "button_background")
        back.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
        back.name = "back"
        back.label.text = "back"
        addChild(back)
        
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
        
        if node.name == "music"  {
           isMusic = !isMusic
            update(node: node as! SKSpriteNode, property: isMusic)
        } else if node.name == "sound" {
            isSound = !isSound
            update(node: node as! SKSpriteNode, property: isSound)
        } else if node.name == "back" {
            print("qqqqqqq")
            gameSettings.isSound = isSound
            gameSettings.isMusic = isMusic
            gameSettings.saveGameSettings()
            
            let transition = SKTransition.crossFade(withDuration: 1.0)
            guard let backScene = backScene else {return}
            backScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(backScene, transition: transition)
        }

    }
    
    func update(node: SKSpriteNode, property: Bool) {
        if let name = node.name {
            node.texture = property ? SKTexture(imageNamed: name) : SKTexture(imageNamed: "no" + name)
        }
    }
}

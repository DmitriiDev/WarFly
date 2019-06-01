//
//  Clouds.swift
//  WarFly
//
//  Created by dmitrii on 01.06.19.
//  Copyright © 2019 dmitrii. All rights reserved.
//

import SpriteKit
import GameplayKit


protocol GameBackgroundSpriteable {
    static func populateSprite(at point: CGPoint) -> Self
}


final class Cloud: SKSpriteNode, GameBackgroundSpriteable {
    
    static func populateSprite(at point: CGPoint) -> Cloud {
        let cloudImageName = configureIslandName()
        let cloud = Cloud(imageNamed: cloudImageName)
        cloud.setScale(randomScaleFactor)
        cloud.position = point
        cloud.zPosition = 10
        return cloud
    }
    
   fileprivate static func configureIslandName() -> String {
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 3)
        let randomNumber = distribution.nextInt()
        let imageName = "cl" + "\(randomNumber)"
        return imageName
    }
    
   fileprivate static var randomScaleFactor: CGFloat {
        let distribution = GKRandomDistribution(lowestValue: 20, highestValue: 30)
        let randomNumber = CGFloat(distribution.nextInt()) / 10
        return randomNumber
    }
    
    
}

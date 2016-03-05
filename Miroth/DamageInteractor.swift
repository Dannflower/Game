//
//  DamageInteractor.swift
//  Miroth
//
//  Created by Eric Ostrowski on 3/5/16.
//  Copyright © 2016 Eric Ostrowski. All rights reserved.
//

import SpriteKit


class DamageInteractor: Actor {
    
    
    var damage: Int = 0
    var owner: Actor! = nil
    
    convenience init(size: CGSize) {
        
        self.init(texture: nil)
        
        self.size = size
        
        let shapeNode = SKShapeNode(rectOfSize: CGSizeMake(16.0, 16.0))
        shapeNode.position = CGPointMake(self.size.width / 2.0, self.size.height / 2.0)
        shapeNode.fillColor = NSColor.redColor()
        
        
        self.addChild(shapeNode)
    }
}
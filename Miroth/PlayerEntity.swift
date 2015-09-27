//
//  PlayerEntity.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/26/15.
//  Copyright (c) 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class PlayerEntity: Entity {
    
    var hitPoints: Int = 0
    
    convenience init() {
        self.init(texture: SpriteLoader.getSpriteTexture(SpriteLoader.Sprite.HumanKnight))
    }
}
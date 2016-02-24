//
//  Weapon.swift
//  Miroth
//
//  Created by Eric Ostrowski on 2/20/16.
//  Copyright © 2016 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class Weapon: Actor {
    
    convenience init() {
        
        self.init(texture: SpriteLoader.getSpriteTexture(SpriteLoader.Sprite.AdventurerMale))
    }
    
    override func isStationaryActor() -> Bool {
        
        return false
    }
}

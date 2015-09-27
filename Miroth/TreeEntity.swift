//
//  Tree.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/26/15.
//  Copyright (c) 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class TreeEntity: Entity {
    
    convenience init() {
        self.init(texture: SpriteLoader.getSpriteTexture(SpriteLoader.Sprite.Tree))
    }
}

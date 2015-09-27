//
//  Entity.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/26/15.
//  Copyright (c) 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class Entity: SKSpriteNode {
    
    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(color: NSColor, size: CGSize) {
        self.init(texture: nil, color: color, size: CGSizeMake(10.0, 10.0))
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
}
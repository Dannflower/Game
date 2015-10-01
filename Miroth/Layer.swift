//
//  Layer.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/30/15.
//  Copyright © 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class Layer: SKSpriteNode {
    
    convenience init(width: Int, height: Int) {
        self.init()
        self.size = CGSizeMake(CGFloat(width), CGFloat(height))
    }
    
    // Func for adding tiles to the layer easily
}
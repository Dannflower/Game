//
//  Object.swift
//  Miroth
//
//  Created by Eric Ostrowski on 1/16/16.
//  Copyright © 2016 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class Object: SKSpriteNode, Collidable {
    
    private var id: Int
    private var type: String
    
    /**

        Returns the object's id.
    
    */
    func getId() -> Int {
        return self.id
    }
    
    /**

        Returns the object's type.

    */
    func getType() -> String {
        return self.type
    }
    
    init(id: Int, type: String, texture: SKTexture?) {
        
        self.id = id
        self.type = type
        
        super.init(texture: texture, color: NSColor.clearColor(), size: texture!.size())
    }
    
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collidedWith(collidable: Collidable) {
        
        // Do nothing.
        // Sub-classes are responsible for their own implementations.
        //print("Object collided with something!")
    }
}

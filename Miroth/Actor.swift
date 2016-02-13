//
//  Actor.swift
//  Miroth
//
//  Created by Eric Ostrowski on 2/12/16.
//  Copyright © 2016 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class Actor: SKSpriteNode {
    
    private var type: String = ""
    
    convenience init(type: String, texture: SKTexture?) {
        
        self.init(texture: texture)
        self.type = type
    }
    
    convenience init(type: String, sprite: SpriteLoader.Sprite) {
        self.init(texture: SpriteLoader.getSpriteTexture(sprite))
    }
    
    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func getType() -> String {
        
        return self.type
    }
    
    /**
     
        Informs this object that it collided with another collidable, allowing
        it to resolve the collision.
     
        - parameter collidable: The Collidable this object is colliding with.
     
     */
    func collidedWith(actors: [Actor]) {
        
        // Sub-classes are responsible for their own implementation.
    }
    
    /**
        
        Returns true if the actor should not be moved, false otherwise.
    */
    func isStationaryActor() -> Bool {
        
        // Actors are stationary by default
        return true
    }
}
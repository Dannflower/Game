//
//  Collidable.swift
//  Miroth
//
//  Created by Eric Ostrowski on 2/5/16.
//  Copyright © 2016 Eric Ostrowski. All rights reserved.
//

import Foundation


protocol Collidable {
    
    /**
        
        The position of the collidable.
    */
    var position: CGPoint { get set }
    
    /**
        
        The size of the collidable.
    */
    var size: CGSize { get set }
    
    /**
        
        Informs this object that it collided with another collidable, allowing
        it to resolve the collision.

        - parameter collidable: The Collidable this object is colliding with.
    */
    func collidedWith(collidable: Collidable)
}
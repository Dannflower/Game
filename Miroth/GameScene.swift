//
//  GameScene.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/15/15.
//  Copyright (c) 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

var character: SKNode? = nil
var destination: CGPoint? = nil

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        character = childNodeWithName("character")
        
    }
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
        // Mark the destination as where the user clicked in the scene
        destination = theEvent.locationInNode(self)
        println("Clicked at: \(destination)")
        
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if destination != nil {
            
            if character?.position != destination {
                
                var currentPosition = CGVector(dx: character!.position.x, dy: character!.position.y)
                var destinationPosition = CGVector(dx: destination!.x, dy: destination!.y)
                
                
                
            }
        }
    }
    
    func distance(start: CGVector, end: CGVector) -> CGFloat {
        
        var differenceVector: CGVector = difference(start, vector2: end)
        
        return sqrt(differenceVector.dx * differenceVector.dx + differenceVector.dy * differenceVector.dy)
    }
    
    func difference(vector1: CGVector, vector2: CGVector) -> CGVector {
        
        return CGVectorMake(vector2.dx - vector1.dx, vector2.dy - vector1.dy)
    }
}

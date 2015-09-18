//
//  GameScene.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/15/15.
//  Copyright (c) 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

let SPEED: CGFloat = 50.0

var character: SKNode? = nil
var destination: CGPoint? = nil
var lastUpdateTime: CFTimeInterval? = nil
var distanceToMove: CGFloat = 0.0

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        character = childNodeWithName("character")
        
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        
        mouseDown(theEvent)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
        // Mark the destination as where the user clicked in the scene
        destination = theEvent.locationInNode(self)
        
        var currentPosition = CGVector(dx: character!.position.x, dy: character!.position.y)
        var destinationPosition = CGVector(dx: destination!.x, dy: destination!.y)
        
        distanceToMove = distance(currentPosition, end: destinationPosition)
            
        println("Clicked at: \(destination)")
        println("Distance to move: \(distanceToMove)")
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if destination != nil {
            
            if character?.position != destination {
                
                var currentPosition = CGVector(dx: character!.position.x, dy: character!.position.y)
                var destinationPosition = CGVector(dx: destination!.x, dy: destination!.y)
                var directionVector = computeDirectionToMoveVector(currentPosition, destinationPosition: destinationPosition)
                var compensatedSpeed = SPEED * CGFloat(currentTime - lastUpdateTime!)
                
                distanceToMove -= length(directionVector) * compensatedSpeed
                
                if distanceToMove > 0.0 {
                    
                    println("Speed: \(compensatedSpeed)")
                    character!.position = computeNewPosition(currentPosition, directionVector: directionVector, speed: compensatedSpeed)
                
                } else {
                    
                    character!.position = destination!
                    distanceToMove = 0.0
                }
            }
        }
        
        lastUpdateTime = currentTime
    }
    
    func distance(start: CGVector, end: CGVector) -> CGFloat {
        
        var differenceVector: CGVector = difference(start, vector2: end)
        
        return length(differenceVector)
    }
    
    func difference(vector1: CGVector, vector2: CGVector) -> CGVector {
        
        return CGVectorMake(vector2.dx - vector1.dx, vector2.dy - vector1.dy)
    }
    
    
    func length(vector: CGVector) -> CGFloat {
        
        return sqrt(vector.dx * vector.dx + vector.dy * vector.dy)

    }
    
    func normalize(vector: CGVector) -> CGVector {
        
        return divide(vector, divisor: length(vector))
    }
    
    func divide(divedend: CGVector, divisor: CGFloat) -> CGVector {
        
        return CGVectorMake(divedend.dx / divisor, divedend.dy / divisor)
    }
    
    func computeDirectionToMoveVector(currentPosition: CGVector, destinationPosition: CGVector) -> CGVector {
        
        return normalize(difference(currentPosition, vector2: destinationPosition))
    }
    
    func computeNewPosition(currentPosition: CGVector, directionVector: CGVector, speed: CGFloat) -> CGPoint {
        
        return CGPointMake(currentPosition.dx + directionVector.dx * speed, currentPosition.dy + directionVector.dy * speed)
    }
}

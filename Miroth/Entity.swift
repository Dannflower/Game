//
//  Entity.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/26/15.
//  Copyright (c) 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class Entity: Actor {
    
    private let SPEED: CGFloat = 100.0
    
    private var destination: CGPoint? = nil
    private var lastUpdateTime: CFTimeInterval? = nil
    private var distanceToMove: CGFloat = 0.0
    private var isMoving: Bool = false
    private var lastValidPosition: CGPoint? = nil
    
    func isEntityMoving() -> Bool {
        
        return self.isMoving
    }
    
    func setDestination(destinationPosition: CGPoint) {
        
        self.destination = destinationPosition
        
        let destinationVector = CGVector(dx: destinationPosition.x, dy: destinationPosition.y)
        let currentPosition = CGVector(dx: self.position.x, dy: self.position.y)
        
        self.distanceToMove = VectorMath.distance(currentPosition, end: destinationVector)
    }
    
    func move(currentTime: CFTimeInterval) {
        self.lastValidPosition = self.position
        
        if destination != nil {
            
            if distanceToMove > 0.0 {
                
                let currentPosition = CGVector(dx: self.position.x, dy: self.position.y)
                let destinationPosition = CGVector(dx: destination!.x, dy: destination!.y)
                let directionVector = VectorMath.computeDirectionToMoveVector(currentPosition, destinationPosition: destinationPosition)
                let compensatedSpeed = SPEED * CGFloat(currentTime - lastUpdateTime!)
                
                distanceToMove -= VectorMath.length(directionVector) * compensatedSpeed
                
                if distanceToMove > 0.0 {
                    
                    self.position = VectorMath.computeNewPosition(currentPosition, directionVector: directionVector, speed: compensatedSpeed)
                    self.isMoving = true
                    
                } else {
                    
                    self.position = destination!
                    distanceToMove = 0.0
                    self.isMoving = false
                }
            }
        }
        
        lastUpdateTime = currentTime
    }
    
    /**
        
        Resolves any collisions this Entity is involved in using default resolution rules.

        - parameter actors: The collection of Actors this Entity is colliding with.
    
    */
    override func collidedWith(actors: [Actor]) {
        
        var blocked: [Actor] = []
        
        // Group Actors by type.
        for actor in actors {
            
            if actor.getType() == "Blocked" {
            
                blocked.append(actor)
            }
        }
        
        // Handle "Blocked" Actor collisions.
        blocked.sortInPlace(sortByOverlapAreaDescending)
        
        for actor in blocked {
            
            // Check that collision is still happening since previous resolutions may have solved this collision.
            if computeXOverlap(self, actorB: actor) > 0.0 || computeYOverlap(self, actorB: actor) > 0.0 {
                
                print("X \(computeXOverlap(self, actorB: actor)) Y: \(computeYOverlap(self, actorB: actor))")
            
                // Resolve the collision on the axis of least separation.
                if computeXOverlap(self, actorB: actor) <= computeYOverlap(self, actorB: actor) {
                
                    if self.position.x <= actor.position.x {
                    
                        // Colliding with the left side, snap to left
                        self.position.x = actor.position.x - self.size.width
                    
                    } else {
                    
                        // Colliding with the right side, snap to right
                        self.position.x = actor.position.x + actor.size.width
                    }
            
                } else {
                
                    if self.position.y <= actor.position.y {
                    
                        // Colliding with the bottom side, snap to bottom
                        self.position.y = actor.position.y - self.size.height
                    
                    } else {
                    
                        // Colliding with the top side, snap to top
                        self.position.y = actor.position.y + actor.size.height
                    }
                }
            }
        }
    }
    
    override func isStationaryActor() -> Bool {
        
        return false
    }
    
    /**
        
        Returns true if actor1 has a larger overlap with this Entity than actor2 does,
        false otherwise.

        - parameter actor1: The Actor being compared to actor2 for overlap area with this Entity.
        - parameter actor2: The Actor being compared to actor1 for overlap area with this Entity.
    
        - returns: True if the overlaping area of actor1 and this Entity is larger than the overlap
                    area of actor2 and this Entity, false otherwise.
    */
    private func sortByOverlapAreaDescending(actor1: Actor, actor2: Actor) -> Bool {
        
        return computeOverlapArea(actor1, actorB: self) > computeOverlapArea(actor2, actorB: self)
    }
    
    /**

        Returns the area of the overlapping section between actorA and actorB.

        - parameter actorA: The Actor intersecting actorB.
        - parameter actorB: The Actor intersecting actorA.

        - returns: The area of the intersection of actorA and actorB.

    */
    private func computeOverlapArea(actorA: Actor, actorB: Actor) -> CGFloat {
        
        return computeXOverlap(actorA, actorB: actorB) * computeYOverlap(actorA, actorB: actorB)
    }
    
    private func computeXOverlap(actorA: Actor, actorB: Actor) -> CGFloat {
        
        let actorAX1 = actorA.position.x
        let actorAX2 = actorA.position.x + actorA.size.width
        let actorBX1 = actorB.position.x
        let actorBX2 = actorB.position.x + actorB.size.width
        
        return max(0.0, min(actorAX2, actorBX2) - max(actorAX1, actorBX1))
    }
    
    private func computeYOverlap(actorA: Actor, actorB: Actor) -> CGFloat {
        
        let actorAY1 = actorA.position.y
        let actorAY2 = actorA.position.y + actorA.size.height
        let actorBY1 = actorB.position.y
        let actorBY2 = actorB.position.y + actorB.size.height
        
        return max(0.0, min(actorAY2, actorBY2) - max(actorAY1, actorBY1))
    }
}
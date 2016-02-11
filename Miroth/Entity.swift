//
//  Entity.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/26/15.
//  Copyright (c) 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class Entity: SKSpriteNode, Collidable {
    
    private let SPEED: CGFloat = 50.0
    
    private var destination: CGPoint? = nil
    private var lastUpdateTime: CFTimeInterval? = nil
    private var distanceToMove: CGFloat = 0.0
    private var isMoving: Bool = false
    private var highlight: SKShapeNode? = nil
    private var layer: Layer? = nil
    private var lastValidPosition: CGPoint? = nil
    private var type: String = ""
    
    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(sprite: SpriteLoader.Sprite) {
        self.init(texture: SpriteLoader.getSpriteTexture(sprite))
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func getType() -> String {
        return self.type
    }
    
    func isEntityMoving() -> Bool {
        
        return self.isMoving
    }
    
    func setLayer(layer: Layer) {
        self.layer = layer
    }
    
    func disableHighlight() {
        
        if let highlightToRemove = self.highlight {
        
            self.removeChildrenInArray([highlightToRemove])
            self.highlight = nil
        }
    }
    
    func enableHighlight() {
        
        disableHighlight()
        
        self.highlight = SKShapeNode(rectOfSize: self.size)
        self.highlight!.antialiased = false
        self.highlight!.strokeColor = SKColor.yellowColor()
        
        self.addChild(highlight!)
    }
    
    func setDestination(destinationPosition: CGPoint) {
        
        self.destination = destinationPosition
        
        let destinationVector = CGVector(dx: destinationPosition.x, dy: destinationPosition.y)
        let currentPosition = CGVector(dx: self.position.x, dy: self.position.y)
        
        self.distanceToMove = VectorMath.distance(currentPosition, end: destinationVector)
    }
    
    func move(currentTime: CFTimeInterval) {
        print(self.position)
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
    
    
    func collidedWith(collidable: Collidable) {
        
        // Do nothing.
        // Sub-classes are responsible for their own implementations.
        print("Entity collided with: \(collidable.getType())")

        if collidable.getType() == "Blocked" {
            
            self.position = self.lastValidPosition!
        }
    }
}
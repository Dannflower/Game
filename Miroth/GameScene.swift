//
//  GameScene.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/15/15.
//  Copyright (c) 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let SPEED: CGFloat = 50.0
    
    var character: PlayerEntity? = nil
    var tree: TreeEntity? = nil
    var destination: CGPoint? = nil
    var lastUpdateTime: CFTimeInterval? = nil
    var distanceToMove: CGFloat = 0.0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // Load the sprite sheets
        var playerSprites: SpriteSheet? = SpriteSheet(texture: SKTexture(imageNamed: "Player0"), rows: 15, columns: 8)
        var treeSprites: SpriteSheet? = SpriteSheet(texture: SKTexture(imageNamed: "Tree0"), rows: 36, columns: 12)
        
        // Select the player sprite
        var playerTexture: SKTexture? = playerSprites?.textureForColumn(2, row: 11)
        playerTexture!.filteringMode = SKTextureFilteringMode.Nearest
        self.character = PlayerEntity(texture: playerTexture)
        self.character!.position = CGPointMake(256, 256)
        
        // Select the tree sprite
        var treeTexture: SKTexture? = treeSprites?.textureForColumn(3, row: 32)
        treeTexture!.filteringMode = SKTextureFilteringMode.Nearest
        self.tree = TreeEntity(texture: treeTexture)
        self.tree!.position = CGPointMake(200, 200)
        
        // Add the new nodes
        self.addChild(self.tree!)
        self.addChild(self.character!)
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
        
        distanceToMove = VectorMath.distance(currentPosition, end: destinationPosition)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if destination != nil {
            
            if distanceToMove > 0.0 {
                
                var currentPosition = CGVector(dx: character!.position.x, dy: character!.position.y)
                var destinationPosition = CGVector(dx: destination!.x, dy: destination!.y)
                var directionVector = VectorMath.computeDirectionToMoveVector(currentPosition, destinationPosition: destinationPosition)
                var compensatedSpeed = SPEED * CGFloat(currentTime - lastUpdateTime!)
                
                distanceToMove -= VectorMath.length(directionVector) * compensatedSpeed
                
                if distanceToMove > 0.0 {
                    
                    character!.position = VectorMath.computeNewPosition(currentPosition, directionVector: directionVector, speed: compensatedSpeed)
                
                } else {
                    
                    character!.position = destination!
                    distanceToMove = 0.0
                }
            }
        }
        
        lastUpdateTime = currentTime
    }
}

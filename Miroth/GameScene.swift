//
//  GameScene.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/15/15.
//  Copyright (c) 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var character: PlayerEntity! = nil
    var map: Map! = nil
    
    override func didMoveToView(view: SKView) {
        
        let mapParser = TmxMapParser()
        
        guard let newMap = mapParser.parseMap("/Users/Eric/Documents/Tiled Maps/demo.tmx", viewSize: self.size) else {
            // For now, exit on error
            print("Failed to load map!")
            exit(1)
        }
        
        self.map = newMap
        
        self.map.position = CGPointMake(CGFloat(map.actualTileSize.width) / 2, CGFloat(map.actualTileSize.height) / 2)
        
        // Select the player sprite
        // Character size should be determined by the size of 1 tile
        self.character = PlayerEntity()
        self.character.position = CGPointMake(self.map.actualTileSize.width * 10 - self.map.actualTileSize.width / 2, self.map.actualTileSize.height * 11 - self.map.actualTileSize.height / 2)
        self.character.zPosition = 4
        self.character.size = map.actualTileSize
        
        self.addChild(self.map)
        self.addChild(self.character)
        
    }
    
    override func keyDown(theEvent: NSEvent) {
        
        // Ignore inputs if the character is already moving
        if(self.character.isEntityMoving()) {
            
            return
        }
        
        var newX: CGFloat = 0.0
        var newY: CGFloat = 0.0
        
        switch theEvent.keyCode {
            
        // Left arrow
        case 123:
            print("Left")
            newX = -self.map.actualTileSize.width
            
        // Right arrow
        case 124:
            print("Right")
            newX = self.map.actualTileSize.width
        
        // Down arrow
        case 125:
            print("Down")
            newY = -self.map.actualTileSize.height
            
        // Up arrow
        case 126:
            print("Up")
            newY = self.map.actualTileSize.height
            
        default:
            print("Ignored key code")
        }
        
        // Compute the new destination to move to
        let destination = CGPointMake(self.character.position.x + newX, self.character.position.y + newY)
        
        self.character.setDestination(destination)
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        
        mouseDown(theEvent)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
        // Mark the destination as where the user clicked in the scene
        let destination = theEvent.locationInNode(self)
        self.character!.setDestination(destination)
        let node = self.nodeAtPoint(destination)
        
        
        if let entity = node as? Entity {
            self.character!.setTarget(entity)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(self.character != nil) {
            self.character!.move(currentTime)
        }
    }

}

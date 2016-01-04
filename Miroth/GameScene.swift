//
//  GameScene.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/15/15.
//  Copyright (c) 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var character: PlayerEntity? = nil
    
    override func didMoveToView(view: SKView) {
        
        let mapParser = TmxMapParser()
        
        guard let map = mapParser.parseMap("/Users/Eric/Documents/Tiled Maps/demo.tmx", viewSize: self.size) else {
            // For now, exit on error
            print("Failed to load map!")
            exit(1)
        }
        
        map.position = CGPointMake(CGFloat(map.actualTileSize.width) / 2, CGFloat(map.actualTileSize.height) / 2)
        
        // Select the player sprite
        // Character size should be determined by the size of 1 tile
        self.character = PlayerEntity()
        self.character!.position = CGPointMake(0, 0)
        self.character!.zPosition = 10
        self.character!.size = map.actualTileSize
        
        self.addChild(map)
        self.addChild(self.character!)
        
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

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
        /* Setup your scene here */
        
        let mapLoader = MapLoader()
        mapLoader.loadMap("/Users/mega_zerox6/Projects/Tiled Maps/DemoMap.tmx")
        
        
        // Select the player sprite
        self.character = PlayerEntity()
        self.character!.position = CGPointMake(256, 256)
        
        // Select the tree sprite
        let tree = TreeEntity()
        tree.position = CGPointMake(200, 200)
        
        let secondTree = TreeEntity()
        secondTree.position = CGPointMake(300, 300)
        
        let thirdTree = TreeEntity()
        thirdTree.position = CGPointMake(100, 250)
        
        // Add the new nodes
        self.addChild(tree)
        self.addChild(secondTree)
        self.addChild(thirdTree)
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

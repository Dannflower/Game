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
        let map = mapLoader.loadMap("/Users/mega_zerox6/Projects/Tiled Maps/DemoMap.tmx")
        let layer = map.layers![0]
        let layer2 = map.layers![1]
        let layer3 = map.layers![2]
        
        layer.position = CGPointMake(200, 200)
        layer2.position = CGPointMake(200, 200)
        layer3.position = CGPointMake(200, 200)
        layer.zPosition = 1
        layer2.zPosition = 2
        layer3.zPosition = 3
        
        // Select the player sprite
        self.character = PlayerEntity()
        self.character!.position = CGPointMake(256, 256)
        self.character!.zPosition = 10
        
        // Select the tree sprite
        let tree = TreeEntity()
        tree.position = CGPointMake(200, 200)
        
        let secondTree = TreeEntity()
        secondTree.position = CGPointMake(300, 300)
        secondTree.zPosition = 9
        
        let thirdTree = TreeEntity()
        thirdTree.position = CGPointMake(100, 250)
        
        // Add the new nodes
        self.addChild(layer)
        self.addChild(layer2)
        self.addChild(layer3)
        //self.addChild(tree)
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

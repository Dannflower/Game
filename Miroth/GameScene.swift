//
//  GameScene.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/15/15.
//  Copyright (c) 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var wDown: Bool = false
    var aDown: Bool = false
    var sDown: Bool = false
    var dDown: Bool = false
    
    var character: PlayerEntity! = nil
    var map: Map! = nil
    
    override func didMoveToView(view: SKView) {
        
        let mapParser = TmxMapParser()
        
        let mapPath = NSBundle.mainBundle().URLForResource("map01", withExtension: "tmx")
        
        guard let newMap = mapParser.parseMap(mapPath!.path!) else {
            // For now, exit on error
            print("Failed to load map!")
            exit(1)
        }
        
        self.map = newMap
        
        // Center the map in the Scene
        self.map.position = CGPointMake(0, 0)
        
        // Get the player entity
        self.character = self.map.getPlayerEntity()
        
        self.addChild(self.map)
        
        // Match the Scene to the size of the newly loaded map
        self.size = self.map.size
        print("GameScene \(self.size)")
        print("Map \(self.map.size)")
    }
    
    override func keyDown(theEvent: NSEvent) {
        
        self.map.checkForAndNotifyOfCollisions()
        
        switch theEvent.keyCode {
            
        // W Key
        case 13:
            
            wDown = true
        
        // A Key
        case 0:
            
            aDown = true
            
        // S Key
        case 1:
            
            sDown = true
            
        // D Key
        case 2:
            
            dDown = true
        
        // Do nothing
        default:
            
            break
        }
    }
    
    override func keyUp(theEvent: NSEvent) {
        
        // Determine if all WASD keys are up, if so, stop movement
        switch theEvent.keyCode {
        
        // W Key
        case 13:
            
            wDown = false
            
        // A Key
        case 0:
            
            aDown = false
            
        // S Key
        case 1:
            
            sDown = false
            
        // D Key
        case 2:
            
            dDown = false
            
        // Do nothing
        default:
            
            break
        }
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
        
        let moveSpeed: CGFloat = 10.0
        var xSpeed: CGFloat = 0.0
        var ySpeed: CGFloat = 0.0
        
        if(self.wDown) {
            ySpeed += moveSpeed
        }
        
        if(self.aDown) {
            xSpeed -= moveSpeed
        }
        
        if(self.sDown) {
            ySpeed -= moveSpeed
        }
        
        if(self.dDown) {
            xSpeed += moveSpeed
        }
        
        let destination = CGPointMake(self.character.position.x + xSpeed, self.character.position.y + ySpeed)
        self.character.setDestination(destination)
        
        /* Called before each frame is rendered */
        if(self.character != nil) {
            self.character!.move(currentTime)
        }
        
        
    }

}

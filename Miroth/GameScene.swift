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
    let mapParser = TmxMapParser()
    
    var character: PlayerEntity! = nil
    var map: Map! = nil
    
    override func didMoveToView(view: SKView) {
        
        let mapPath = NSBundle.mainBundle().URLForResource("map_7Soul", withExtension: "tmx")
        
        guard let newMap = self.mapParser.parseMap(mapPath!.path!) else {
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
    }
    
    override func keyDown(theEvent: NSEvent) {
        
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
        
        case 38:
            
            self.character.attack()
            
        case 122:
            
            switchToMap("map_7Soul1")
            
        case 120:
            
            switchToMap("map_7Soul")
            
        // Do nothing
        default:
            print(theEvent.keyCode)
            
        }
    }
    
    func switchToMap(mapName: String) {
        
        self.removeAllChildren()
        
        let mapPath = NSBundle.mainBundle().URLForResource(mapName, withExtension: "tmx")
        
        guard let newMap = self.mapParser.parseMap(mapPath!.path!) else {
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
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        // TODO: Control of the player characters should be abstracted from the GameScene class.
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
        
        if self.character != nil {
        
            self.character.setDestination(destination)
        }
        
        self.map.update(currentTime)
    }

}

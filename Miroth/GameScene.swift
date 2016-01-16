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
        
        guard let newMap = mapParser.parseMap(mapPath!.path!, viewSize: self.size) else {
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
            
        // W Key
        case 13:
            print("W")
            wDown = true
        
        // A Key
        case 0:
            print("A")
            aDown = true
            
        // S Key
        case 1:
            print("S")
            sDown = true
            
        // D Key
        case 2:
            print("D")
            dDown = true
            
        default:
            print("Code: \(theEvent.keyCode)")
        }
        
        // Compute the new destination to move to
        let destination = CGPointMake(self.character.position.x + newX, self.character.position.y + newY)
        
        self.character.setDestination(destination)
    }
    
    override func keyUp(theEvent: NSEvent) {
        
        // Determine if all WASD keys are up, if so, stop movement
        switch theEvent.keyCode {
        
        // W Key
        case 13:
            print("W up")
            wDown = false
            
        // A Key
        case 0:
            print("A up")
            aDown = false
            
        // S Key
        case 1:
            print("S up")
            sDown = false
            
        // D Key
        case 2:
            print("D up")
            dDown = false
            
        default:
            print("Code: \(theEvent.keyCode)")
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

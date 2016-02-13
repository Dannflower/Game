//
//  Layer.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/30/15.
//  Copyright © 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class Layer: SKSpriteNode {
    
    private var layerName: String = ""
    
    private var tiles: [[SKSpriteNode]] = []
    
    private var currentTile = 0
    
    private var tileHeight: Int = 0
    private var tileWidth: Int = 0
    
    private var heightInTiles: Int = 0
    private var widthInTiles: Int = 0
    
    private var actors: [Actor] = []
    private var movingActors: [Actor] = []
    private var stationaryActors: [Actor] = []
    
    // Actual tile size
    var actualTileSize: CGSize {
        get {
            return CGSizeMake(self.size.width / CGFloat(widthInTiles), self.size.height / CGFloat(heightInTiles))
        }
    }
    
    convenience init(name: String, widthInTiles: Int, heightInTiles: Int, tileWidth: Int, tileHeight: Int) {
        
        self.init()
        
        self.layerName = name
        self.heightInTiles = heightInTiles
        self.widthInTiles = widthInTiles
        self.tileHeight = tileHeight
        self.tileWidth = tileWidth
        
        // Initialize the layer with a set of untextured tiles
        self.tiles = [[SKSpriteNode]](
            count: heightInTiles,
            repeatedValue:[SKSpriteNode](
                count: widthInTiles,
                repeatedValue: SKSpriteNode()))
    }
    
    /**
     
     Adds the SKSpriteNode to the next tile position in the
     layer (tiles are added to rows from left to right
     moving to the next row after the previous is filled).
     
     - parameter tile: The tile to add to the layer.
     
     
     */
    func addNextTile(tile: SKSpriteNode) {
        
        tile.size = self.actualTileSize
        
        // Position tiles using lower-left corner of bounding box
        tile.anchorPoint = CGPointMake(0, 0)
        
        if self.currentTile == 0 {
            
            // First tile is a special case since division by zero is bad
            self.tiles[0][0] = tile
            tile.position = CGPointMake(0, CGFloat((self.heightInTiles - 1)) * tile.size.height)
            print(tile.position)
        
        } else {
            
            let currentRow = self.heightInTiles - 1 - self.currentTile / self.widthInTiles
            let currentColumn = self.currentTile % self.widthInTiles
            
            // Ensure too many tiles aren't added
            assert(currentRow < self.heightInTiles, "Too many tiles added to layer: \(self.layerName)")
            
            self.tiles[currentRow][currentColumn] = tile
            
            // Position the tile
            tile.position = CGPointMake(CGFloat(currentColumn) * tile.size.width, CGFloat(currentRow) * tile.size.width)
        }
        
        // Add the tile to the layer
        self.addChild(tile)
        
        // Move to the next tile
        currentTile += 1
    }
    
    private func addCollision(actorA: Actor, actorB: Actor, inout collisions: [Actor : [Actor]]) {
        
        // Add the collision for actorA
        if var actorCollisions = collisions[actorA] {
            
            actorCollisions.append(actorB)
        
        } else {
            
            collisions[actorA] = [actorB]
        }
        
        // Add the collision for actorB
        if var actorCollisions = collisions[actorB] {
            
            actorCollisions.append(actorA)
            
        } else {
            
            collisions[actorB] = [actorA]
        }
    }
    
    /**

        Checks for collisions on this layer and informs the colliding objects.

    */
    func checkForAndNotifyOfCollisions() {
        
        var collisions: [Actor: [Actor]] = [:]
        
        // Check moving Actors against each other
        for var i = 0; i < self.movingActors.count - 1; i++ {
            
            for var j = i + 1; j < self.movingActors.count; j++ {
                
                let actorA = self.movingActors[i]
                let actorB = self.movingActors[j]
                
                if checkForCollisionBetween(actorA, actorB: actorB) {
                    
                    addCollision(actorA, actorB: actorB, collisions: &collisions)
                }
                
            }
        }
        
        // Check moving Actors against stationary ones
        for var i = 0; i < self.movingActors.count; i++ {
            
            for var j = 0; j < self.stationaryActors.count; j++ {
                
                let actorA = self.movingActors[i]
                let actorB = self.stationaryActors[j]
                
                if checkForCollisionBetween(actorA, actorB: actorB) {
                    
                    addCollision(actorA, actorB: actorB, collisions: &collisions)
                }
            }
        }
        
        // Inform all Actors involved in collisions of the Actors they collided with.
        for (collider, collidees) in collisions {
            
            collider.collidedWith(collidees)
        }
    }
    
    /**

        Checks if there is a collision between the two specified Actors.

        - parameter actorA: The Actor being checked for a collision with ActorB.
        - parameter actorB: The Actor being checked for a collision with ActorA.

        - returns: True if there is a collision between actorA and actorB, false otherwise.
     
    */
    private func checkForCollisionBetween(actorA: Actor, actorB: Actor) -> Bool {
        
        let actorAXLowerBound = actorA.position.x
        let actorAXUpperBound = actorA.position.x + actorA.size.width
        
        let actorAYLowerBound = actorA.position.y
        let actorAYUpperBound = actorA.position.y + actorA.size.height
        
        let actorBXLowerBound = actorB.position.x
        let actorBXUpperBound = actorB.position.x + actorB.size.width
        
        let actorBYLowerBound = actorB.position.y
        let actorBYUpperBound = actorB.position.y + actorB.size.height
        
        // Checks for gaps on the X and Y axis between the objects
        if(actorAXLowerBound < actorBXUpperBound && actorAXUpperBound > actorBXLowerBound) {
            
            if(actorAYLowerBound < actorBYUpperBound && actorAYUpperBound > actorBYLowerBound) {
                
                // Collision
                return true
            }
        }
        
        return false
    }

    /**
        
        Adds an Actor to the layer at the coordinates specified.

        - parameter actor: The Actor being added to the layer.
        - parameter x: The x-coordinate of the location where the Entity is being added.
        - parameter y: The y-coordinate of the location where the Entity is being added.
     
    */
    func addActor(actor: Actor, x: CGFloat, y: CGFloat) {
        
        addSpriteNodeAboveLayer(actor, x: x, y: y)
        self.actors.append(actor)
        
        if(actor.isStationaryActor()) {
            
            self.stationaryActors.append(actor)
        
        } else {
            
            self.movingActors.append(actor)
        }
        
    }
    
    /**

        Adds a SpriteNode to the layer, above the tiles, at the coordinates specified after converting
        TMX coordinates to SpriteKit coordinates.

        - parameter node: The SpriteNode being added to the layer.
        - parameter tmxX: The TMX x-coordinate of the location the node is being added to the layer.
        - parameter tmxY: The TMX y-coordinate of the location the node is being added to the layer.
    */
    private func addSpriteNodeAboveLayer(node: SKSpriteNode, x: CGFloat, y: CGFloat) {
        
        // Position node above tiles of this layer (this is 0.5 above this layer's z-position)
        node.zPosition = 0.5
        
        // Force objects to match tile size
        node.size = self.actualTileSize
        
        // Position using lower-left corner
        node.anchorPoint = CGPointMake(0, 0)
        node.position = CGPointMake(x, y)
        
        self.addChild(node)
    }
}
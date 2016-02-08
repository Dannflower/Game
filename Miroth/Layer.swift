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
    
    private var objects: [Object] = []
    private var entities: [Entity] = []
    private var movingCollidables: [Collidable] = []
    private var stationaryCollidables: [Collidable] = []
    
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
        
        if self.currentTile == 0 {
            
            // First tile is a special case since division by zero is bad
            self.tiles[0][0] = tile
            tile.position = CGPointMake(tile.size.width / 2, CGFloat((self.heightInTiles - 1)) * tile.size.height + (tile.size.height / 2))
        
        } else {
            
            let currentRow = self.heightInTiles - 1 - self.currentTile / self.widthInTiles
            let currentColumn = self.currentTile % self.widthInTiles
            
            // Ensure too many tiles aren't added
            assert(currentRow < self.heightInTiles, "Too many tiles added to layer: \(self.layerName)")
            
            self.tiles[currentRow][currentColumn] = tile
            
            // Position the tile
            tile.position = CGPointMake(CGFloat(currentColumn) * tile.size.width + (tile.size.width / 2), CGFloat(currentRow) * tile.size.width + (tile.size.height / 2))
        }
        
        // Add the tile to the layer
        self.addChild(tile)
        
        // Move to the next tile
        currentTile += 1
    }
    
    /**

        Checks for collisions on this layer and informs the colliding objects.

    */
    func checkForAndNotifyOfCollisions() {
        
        // Check moving collidables against each other
        for var i = 0; i < self.movingCollidables.count - 1; i++ {
            
            for var j = i + 1; j < self.movingCollidables.count; j++ {
                
                let collidableA = self.movingCollidables[i]
                let collidableB = self.movingCollidables[j]
                
                if checkForCollisionBetween(collidableA, collidableB: collidableB) {
                    
                    // Inform the collidables that they collided
                    collidableA.collidedWith(collidableB)
                    collidableB.collidedWith(collidableA)
                }
                
            }
        }
        
        // Check moving collidables against stationary ones
        for var i = 0; i < self.movingCollidables.count; i++ {
            
            for var j = 0; j < self.stationaryCollidables.count; j++ {
                
                let collidableA = self.movingCollidables[i]
                let collidableB = self.stationaryCollidables[j]
                
                if checkForCollisionBetween(collidableA, collidableB: collidableB) {
                    
                    // Inform the collidables that they collided
                    collidableA.collidedWith(collidableB)
                    collidableB.collidedWith(collidableA)
                }
            }
        }
    }
    
    /**

        Checks if there is a collision between the two specified Collidables.

        - parameter collidableA: The Collidable being checked for a collision with CollidableB.
        - parameter collidableB: The collidable being checked for a collision with CollidableA.

        - returns: True if there is a collision between collidableA and collidableB, false otherwise.
     
    */
    private func checkForCollisionBetween(collidableA: Collidable, collidableB: Collidable) -> Bool {
        
        let collidableAXLowerBound = collidableA.position.x - collidableA.size.width / 2
        let collidableAXUpperBound = collidableA.position.x + collidableA.size.width / 2
        
        let collidableAYLowerBound = collidableA.position.y - collidableA.size.height / 2
        let collidableAYUpperBound = collidableA.position.y + collidableA.size.height / 2
        
        let collidableBXLowerBound = collidableB.position.x - collidableB.size.width / 2
        let collidableBXUpperBound = collidableB.position.x + collidableB.size.width / 2
        
        let collidableBYLowerBound = collidableB.position.y - collidableB.size.height / 2
        let collidableBYUpperBound = collidableB.position.y + collidableB.size.height / 2
        
        // This only works if both A and B are identical in size.
        if collidableAXLowerBound > collidableBXLowerBound && collidableAXLowerBound < collidableBXUpperBound {
            
            if collidableAYLowerBound > collidableBYLowerBound && collidableAYLowerBound < collidableBYUpperBound {
                
                // Bottom-left corner of A is in B. Rounding error on this one is causing it to trigger
                return true
                
            } else if collidableAYUpperBound > collidableBYLowerBound && collidableAYUpperBound < collidableBYUpperBound {
                
                // Upper-left corner of A is in B.
                return true
            }
            
        } else if collidableAXUpperBound > collidableBXLowerBound && collidableAXUpperBound < collidableBXUpperBound {
            
            if collidableAYLowerBound > collidableBYLowerBound && collidableAYLowerBound < collidableBYUpperBound {
                
                // Bottom-right corner of A is in B.
                return true
                
            } else if collidableAYUpperBound > collidableBYLowerBound && collidableAYUpperBound < collidableBYUpperBound {
                
                // Upper-right corner of A is in B.
                return true
            }
        }
        
        return false
    }

    /**
        
        Adds an Entity to the layer at the coordinates specified.

        - parameter entity: The Entity being added to the layer.
        - parameter x: The x-coordinate of the location where the Entity is being added.
        - parameter y: The y-coordinate of the location where the Entity is being added.
     
    */
    func addEntity(entity: Entity, x: CGFloat, y: CGFloat) {
        
        entity.setLayer(self)
        addSpriteNodeAboveLayer(entity, x: x, y: y)
        self.entities.append(entity)
        self.movingCollidables.append(entity)
    }

    /**

        Adds an Object to the layer at the coordinates specified.

        - parameter object: The object being added to the layer.
        - parameter x: The x-coordinate of the location where the Object is being added.
        - parameter y: The y-coordinate of the location where the Object is being added.
    */
    func addObject(object: Object, x: CGFloat, y: CGFloat) {
        
        addSpriteNodeAboveLayer(object, x: x, y: y)
        self.objects.append(object)
        self.stationaryCollidables.append(object)
    }
    
    /**

        Adds a SpriteNode to the layer, above the tiles, at the coordinates specified after converting
        TMX coordinates to SpriteKit coordinates.

        - parameter node: The SpriteNode being added to the layer.
        - parameter tmxX: The TMX x-coordinate of the location the node is being added to the layer.
        - parameter tmxY: The TMX y-coordinate of the location the node is being added to the layer.
    */
    private func addSpriteNodeAboveLayer(node: SKSpriteNode, x: CGFloat, y: CGFloat) {
        
        // Position object above tiles of this layer
        node.zPosition = self.zPosition + 0.5
        
        // Force objects to match tile size
        node.size = self.actualTileSize
        
        // Adjust for node's anchor point
        node.position = CGPointMake(x + node.size.width / 2, y + node.size.height / 2)
        
        self.addChild(node)
    }
}
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
    
    // Two-dimensional array of tile SpriteNodes that make layer.
    private var tiles: [[SKSpriteNode]] = []
    
    // The current tile
    private var currentTile = 0
    
    private var tileHeight: Int = 0
    private var tileWidth: Int = 0
    
    private var heightInTiles: Int = 0
    private var widthInTiles: Int = 0
    
    private var objects: [Object] = []
    private var entities: [Entity] = []
    private var collidables: [Collidable] = []
    
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
    
    func addNextTile(tile: SKSpriteNode) {
        
        tile.size = self.actualTileSize
        
        if self.currentTile == 0 {
            
            // First tile is a special case since division by zero is bad
            self.tiles[0][0] = tile
            tile.position = CGPointMake(0, CGFloat((self.heightInTiles - 1)) * self.size.height / CGFloat(self.heightInTiles))
        
        } else {
            
            let currentRow = self.heightInTiles - 1 - self.currentTile / self.widthInTiles
            let currentColumn = self.currentTile % self.widthInTiles
            
            // Ensure too many tiles aren't added
            assert(currentRow < self.heightInTiles, "Too many tiles added to layer: \(self.layerName)")
            
            self.tiles[currentRow][currentColumn] = tile
            
            // Position the tile
            tile.position = CGPointMake(CGFloat(currentColumn) * self.size.width / CGFloat(self.widthInTiles), CGFloat(currentRow) * self.size.height / CGFloat(self.heightInTiles))
        }
        
        // Add the tile to the layer
        self.addChild(tile)
        
        // Move to the next tile
        currentTile += 1
    }
    
    /**

        Checks for collisions on this layer and informs the colliding objects.

        - parameter node: The node being checked for collisions.

    */
    func checkForAndNotifyOfCollisions() {
        
        for var i = 0; i < self.collidables.count - 1; i++ {
            
            for var j = i + 1; j < self.collidables.count; j++ {
                
                var collisionDetected = false
                
                let collidableA = self.collidables[i]
                let collidableB = self.collidables[j]
                
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
                        collisionDetected = true
                    
                    } else if collidableAYUpperBound > collidableBYLowerBound && collidableAYUpperBound < collidableBYUpperBound {
                        
                        // Upper-left corner of A is in B.
                        collisionDetected = true
                    }
                
                } else if collidableAXUpperBound > collidableBXLowerBound && collidableAXUpperBound < collidableBXUpperBound {
                    
                    if collidableAYLowerBound > collidableBYLowerBound && collidableAYLowerBound < collidableBYUpperBound {
                        
                        // Bottom-right corner of A is in B.
                        collisionDetected = true
                    
                    } else if collidableAYUpperBound > collidableBYLowerBound && collidableAYUpperBound < collidableBYUpperBound {
                        
                        // Upper-right corner of A is in B.
                        collisionDetected = true
                    }
                }
                
                if collisionDetected {
                    
                    // Inform the collidables that they collided.
                    collidableA.collidedWith(collidableB)
                    collidableB.collidedWith(collidableA)
                }
            }
        }
    }
    
    func addEntity(entity: Entity, x: CGFloat, y: CGFloat) {
        
        entity.setLayer(self)
        addSpriteNodeAboveLayer(entity, x: x, y: y)
        self.entities.append(entity)
        self.collidables.append(entity)
    }
    
    func addObject(object: Object) {
        
        addSpriteNodeAboveLayer(object, x: object.getX(), y: object.getY())
        self.objects.append(object)
        self.collidables.append(object)
    }
    
    private func addSpriteNodeAboveLayer(node: SKSpriteNode, x: CGFloat, y: CGFloat) {
        
        // Force the object between this layer and the next
        node.zPosition = self.zPosition + 0.5
        
        node.size = self.actualTileSize
        
        let xScale: CGFloat = self.size.width / CGFloat(self.tileWidth * self.widthInTiles)
        let yScale: CGFloat = self.size.height / CGFloat(self.tileHeight * self.heightInTiles)
        
        node.position = CGPointMake(x * xScale, self.size.height - (y * yScale))
        
        self.addChild(node)
    }
}
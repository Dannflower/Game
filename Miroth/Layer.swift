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
    
    // Two dimensional array of SKSpriteNodes
    private var tiles: [[SKSpriteNode]] = []
    private var currentTile = 0
    
    private var heightInTiles: Int = 0
    private var widthInTiles: Int = 0
    
    // Actual tile size
    var actualTileSize: CGSize {
        get {
            return CGSizeMake(self.size.width / CGFloat(widthInTiles), self.size.height / CGFloat(heightInTiles))
        }
    }
    
    convenience init(name: String, widthInTiles: Int, heightInTiles: Int) {
        
        self.init()
        
        self.layerName = name
        self.heightInTiles = heightInTiles
        self.widthInTiles = widthInTiles
        
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
    
    func addObject(object: Object) {
        
        self.addChild(object)
    }
}
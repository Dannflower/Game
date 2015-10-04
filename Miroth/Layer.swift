//
//  Layer.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/30/15.
//  Copyright © 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class Layer: SKSpriteNode {
    
    // Two dimensional array of SKSpriteNodes
    private var tiles: [[SKSpriteNode]] = []
    var currentTile = 0
    var layerName: String? = nil
    var tileHeight: Int? = nil
    var tileWidth: Int? = nil
    var heightInTiles: Int = 0
    var widthInTiles: Int = 0
    
    
    convenience init(name: String, widthInTiles: Int, heightInTiles: Int, tileHeight: Int, tileWidth: Int) {
        
        self.init()
        
        self.name = name
        self.size = CGSizeMake(CGFloat(widthInTiles * tileWidth), CGFloat(heightInTiles * tileHeight))
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
        
        if self.currentTile == 0 {
            
            // First tile is a special case since division by zero is bad
            self.tiles[0][0] = tile
            tile.position = CGPointMake(0, CGFloat((self.heightInTiles - 1) * self.tileHeight!))
        
        } else {
            
            let currentRow = self.heightInTiles - 1 - self.currentTile / self.widthInTiles
            let currentColumn = self.currentTile % self.widthInTiles
            
            // Ensure too many tiles aren't added
            assert(currentRow < self.heightInTiles, "Too many tiles added to layer: \(layerName)")
            
            self.tiles[currentRow][currentColumn] = tile
            
            // Position the tile
            tile.position = CGPointMake(CGFloat(currentColumn * tileWidth!), CGFloat(currentRow * tileHeight!))
        }
        
        // Add the tile to the layer
        self.addChild(tile)
        
        // Move to the next tile
        currentTile += 1
    }
}
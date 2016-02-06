//
//  Map.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/30/15.
//  Copyright © 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class Map: SKSpriteNode {
    
    // File define tile size
    private var tileHeight: Int = 0
    private var tileWidth: Int = 0
    
    private var widthInTiles: Int = 0
    private var heightInTiles: Int = 0
    
    private var player: PlayerEntity? = nil
    
    // The set of layers that make up this map
    private var layers: [Layer] = []
    
    // Actual tile size
    var actualTileSize: CGSize {
        get {
            return CGSizeMake(self.size.width / CGFloat(widthInTiles), self.size.height / CGFloat(heightInTiles))
        }
    }
    
    func setTileHeight(tileHeight: Int) {
        self.tileHeight = tileHeight
    }
    
    func setTileWidth(tileWidth: Int) {
        self.tileWidth = tileWidth
    }
    
    func setWidthInTiles(widthInTiles: Int) {
        self.widthInTiles = widthInTiles
    }
    
    func setHeightInTiles(heightInTiles: Int) {
        self.heightInTiles = heightInTiles
    }
    
    func getTileWidth() -> Int {
        return self.tileWidth
    }
    
    func getTileHeight() -> Int {
        return self.tileHeight
    }
    
    func getLayer(layerPosition: Int) -> Layer {
        
        return self.layers[layerPosition]
    }
    
    func getPlayerEntity() -> PlayerEntity? {
        
        return self.player
    }
    
    /**
        Creates a new Map with the specified
        width and height.
     
        - param widthInTiles The width of the map in tiles.
        - param heightInTiles The height of the map in tiles.
        - param tileHeight The height of a single tile.
        - param tileWidth The width of a single tile.
    */
    convenience init(widthInTiles: Int, heightInTiles: Int, tileHeight: Int, tileWidth: Int) {
        self.init()
        self.size = CGSizeMake(CGFloat(widthInTiles * tileWidth), CGFloat(heightInTiles * tileHeight))
        self.tileHeight = tileHeight
        self.tileWidth = tileWidth
        self.widthInTiles = widthInTiles
        self.heightInTiles = heightInTiles
    }
    
    /**
        
        Adds a new layer to the map on top of previous layers.

        - param layer The layer being added to the map.
    */
    func addLayer(layer: Layer) {
        
        // Add the layer on top of previous layers
        layer.zPosition = CGFloat(self.layers.count)
        
        // Place the layer at the origin of the map
        layer.position = CGPointMake(0, 0)
        
        // Force layers to be the same size as the map
        layer.size = self.size

        self.addChild(layer)
        self.layers.append(layer)
    }
    
    func addNextTileToLayer(layerNumber: Int, tile: SKSpriteNode) {
        
        self.layers[layerNumber].addNextTile(tile)
    }
    
    func addObjectToLayer(layerNumber: Int, object: Object) {
        
        switch object.getType() {
            
        case "Blocked":
            
            // Blockers should be transparent
            object.texture = nil
            self.layers[layerNumber].addObject(object)
            
        case "Spawn:Player":
            
            // Create a new player
            self.player = PlayerEntity()
            self.layers[layerNumber].addEntity(self.player!, x: object.getX(), y: object.getY())
            
            
        default:
            break
        }
    }
    
    func checkForAndNotifyOfCollisions() {
        
        for layer in self.layers {
            
            layer.checkForAndNotifyOfCollisions()
        }
    }
}

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
    
    /**
        Creates a new Map with the specified
        width and height.
    
        - param widthInTiles The width of the map in tiles.
        - param heightInTiles The height of the map in tiles.
    */
    convenience init(viewSize: CGSize, widthInTiles: Int, heightInTiles: Int, tileHeight: Int, tileWidth: Int) {
        self.init()
        self.size = viewSize
        self.tileHeight = tileHeight
        self.tileWidth = tileWidth
        self.widthInTiles = widthInTiles
        self.heightInTiles = heightInTiles
    }
    
    convenience init(viewSize: CGSize) {
        self.init()
        self.size = viewSize
    }
    
    // Adds a new layer to the map on top of previous layers
    func addLayer(layer: Layer) {
        // Add the layer on top of previous layers
        layer.zPosition = CGFloat(self.layers.count)
        layer.position = CGPointMake(0, 0)
        // Force layers to fill the map
        layer.size = self.size

        self.addChild(layer)
        self.layers.append(layer)
    }
    
    func addNextTileToLayer(layerNumber: Int, tile: SKSpriteNode) {
        
        self.layers[layerNumber].addNextTile(tile)
    }
    
    func addObjectToLayer(layerNumber: Int, object: Object) {
        
        handleObjectType(object)
        
        self.layers[layerNumber].addObject(object)
    }
    
    private func handleObjectType(object: Object) {
        
        switch object.getType() {
            
        case "Blocked":
            // Blockers should be transparent
            object.texture = nil
            
        case "Spawn:Player":
            // Add the PlayerEntity to the map
            break
            
        default:
            break
        }
    }
}

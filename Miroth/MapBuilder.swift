//
//  MapBuilder.swift
//  Miroth
//
//  Created by Eric Ostrowski on 1/3/16.
//  Copyright © 2016 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class MapBuilder {
    
    // The map
    private var map: Map
    
    // Maps tile GID to the tileset it belongs to and its place in the tileset
    private var tilesetDict: [Int : (tileset: Tileset, tileNumber: Int)] = [:]
    
    // The current Tileset being built
    private var currentTileset: Tileset! = nil
    
    // The current TileLayer being built
    private var currentLayer: Layer! = nil
    
    // Error types
    enum MapLoaderError: ErrorType {
        
        case MissingAttribute(attributeName: String)
        case MalformedAttribute(attributeName: String)
    }
    
    init(mapViewSize: CGSize) {
        
        map = Map(viewSize: mapViewSize)
    }
    
    func getMap() -> Map {
        
        return self.map
    }
    
    func createMap(widthInTiles: Int, heightInTiles: Int, tileHeight: Int, tileWidth: Int) {
        
        // Configure the map
        self.map.setWidthInTiles(widthInTiles)
        self.map.setHeightInTiles(heightInTiles)
        self.map.setTileHeight(tileHeight)
        self.map.setTileWidth(tileWidth)
    }
    
    func createTileset(name: String, firstGid: Int, tileCount: Int, tileHeight: Int, tileWidth: Int) {
        
        // Determine the GID range for the tileset
        let lastGid = firstGid + tileCount
        
        //Create a new tileset
        self.currentTileset = Tileset(
            name: name,
            tileHeight: tileHeight,
            tileWidth: tileWidth,
            firstGid: firstGid,
            lastGid: lastGid)
    }
    
    func setTilesetSource(source: String, height: Int, width: Int) {
        
        // Finish initializing the tileset
        self.currentTileset.cleanAndSetSource(source)
        self.currentTileset.height = height
        self.currentTileset.width = width
        
        var tileNumber = 0
        
        // Assign a tileset and tile number to each GID
        for gid in self.currentTileset.gidRange {
            
            tilesetDict[gid] = (self.currentTileset, tileNumber++)
        }
    }
    
    func addObjectToLayer(id: Int, type: String, gid: Int, x: Int, y: Int, width: Int, height: Int) {
        
        // Get the object's sprite
        let objectSprite = convertGidToSpriteNode(gid)
        
        // Create the object
        let object = Object(id: id, type: type, texture: objectSprite)
        
        self.currentLayer.addObject(object)
    }
    
    /**

        Creates a new active layer.

        - parameter name: The name of the layer.
        - parameter widthInTiles: The width of the layer measured in tiles.
        - parameter heightInTiles: The height of the layer measured in tiles.

    */

    func createLayer(name: String, widthInTiles: Int, heightInTiles: Int) {
        
        // Create a new layer
        self.currentLayer = Layer(
            name: name,
            widthInTiles: widthInTiles,
            heightInTiles: heightInTiles)
        
        self.map.addLayer(self.currentLayer)
    }
    
    func addTileToLayer(gid: Int) {
        
        // Get the texture
        let tileTexture = convertGidToSpriteNode(gid)
        
        // Create the tile
        let tile = SKSpriteNode(texture: tileTexture)
        
        // Add the tile to the layer being built
        self.currentLayer.addNextTile(tile)
    }
    
    // Given a GID, create a sprite node with the texture
    // of the tile that corresponds to the GID
    private func convertGidToSpriteNode(gid: Int) -> SKTexture? {
        
        var texture: SKTexture? = nil
        
        // If GID isn't mapped, assume it's an empty tile (i.e. GID zero)
        if let tilesetAndNumber = self.tilesetDict[gid] {
            
            let tileset = tilesetAndNumber.tileset
            let tileNumber = tilesetAndNumber.tileNumber
            
            // Convert the tile number into a row/column position
            let row = tileset.rows - 1 - tileNumber / tileset.columns
            let column = tileNumber % tileset.columns
            
            texture = SpriteLoader.getSpriteTexture(tileset.source, column: column, row: row)
        }
        
        return texture
    }
}
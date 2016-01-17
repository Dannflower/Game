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
    private var currentLayer: Int = -1
    
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
    
    /**

        Adds an object to the current layer.

        - parameter id: The object id.
        - parameter type: The type of the object.
        - parameter gid: The global texture id of the object's sprite.
        - parameter x: The x-coordinate of the object on the layer.
        - parameter y: The y-coordinage of the object on the layer.
        - parameter width: The width of the object.
        - parameter height: The height of the object.

    */

    func addObjectToLayer(id: Int, type: String, gid: Int, x: CGFloat, y: CGFloat, width: Int, height: Int) {
        
        // Get the object's sprite
        let objectSprite = convertGidToSpriteNode(gid)
        
        // Create the object
        let object = Object(id: id, type: type, texture: objectSprite, x: x, y: y)
        
        // Add it to the layer
        self.map.addObjectToLayer(self.currentLayer, object: object)
    }
    
    /**

        Creates a new layer and makes it the current layer.

        - parameter name: The name of the layer.
        - parameter widthInTiles: The width of the layer measured in tiles.
        - parameter heightInTiles: The height of the layer measured in tiles.

    */

    func createLayer(name: String, widthInTiles: Int, heightInTiles: Int) {
        
        // Create a new layer
        let layer = Layer(
            name: name,
            widthInTiles: widthInTiles,
            heightInTiles: heightInTiles,
            tileWidth: self.map.getTileWidth(),
            tileHeight: self.map.getTileHeight())
        
        self.map.addLayer(layer)
        self.currentLayer++
    }
    
    func addTileToLayer(gid: Int) {
        
        // Get the texture
        let tileTexture = convertGidToSpriteNode(gid)
        
        // Create the tile
        let tile = SKSpriteNode(texture: tileTexture)
        
        // Add the tile to the layer being built
        self.map.addNextTileToLayer(self.currentLayer, tile: tile)
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
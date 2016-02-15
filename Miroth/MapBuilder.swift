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
    private var map: Map! = nil
    
    // Maps tile GID to the tileset it belongs to and its place in the tileset
    private var tilesetDict: [Int : (tileset: Tileset, tileNumber: Int)] = [:]
    
    // The current Tileset being built
    private var currentTileset: Tileset! = nil
    
    // The current TileLayer being built
    private var currentLayer: Int = -1
    
    // The size of the current layer being built
    private var currentLayerSize: CGSize! = nil
    
    // Error types
    enum MapLoaderError: ErrorType {
        
        case MissingAttribute(attributeName: String)
        case MalformedAttribute(attributeName: String)
    }
    
    init() {
        
        self.map = Map()
    }
    
    func getMap() -> Map {
        
        return self.map
    }
    
    /**

        Creates an empty map with the specified properties.

        - parameter widthInTiles: The width of the map measured in tiles.
        - parameter heightInTiles: The height of the map measured in tiles.
        - parameter tileHeight: The height of tiles used in the map.
        - parameter tileWidth: The width of tiles used in the map.
    */
    func createMap(widthInTiles: Int, heightInTiles: Int, tileHeight: Int, tileWidth: Int) {
        
        // Configure the map
        self.map = Map(
            widthInTiles: widthInTiles,
            heightInTiles: heightInTiles,
            tileHeight: tileHeight,
            tileWidth: tileWidth)
    }
    
    /**

        Creates a new Tileset with the specified properties.

        - parameter name: The name of the tileset.
        - parameter firstGid: The GID of the first tile in the tileset.
        - parameter tileCount: The number of tiles in the tileset.
        - parameter tileHeight: The height of a single tile in the tileset.
        - parameter tileWidth: The width of a single tile in the tileset.
    */
    func createTileset(name: String, firstGid: Int, tileCount: Int, tileHeight: Int, tileWidth: Int, spacing: Int, margin: Int) {
        
        // Determine the GID range for the tileset
        let lastGid = firstGid + tileCount
        
        //Create a new tileset
        self.currentTileset = Tileset(
            name: name,
            tileHeight: tileHeight,
            tileWidth: tileWidth,
            firstGid: firstGid,
            lastGid: lastGid,
            spacing: spacing,
            margin: margin)
    }
    
    /**

        Sets the source file of the current Tileset.

        - parameter source: The file path to the source image of the Tileset.
        - parameter height: The height in pixels of the source image.
        - parameter width: The width in pixels of the source image.
    */
    func setTilesetSource(source: String, height: Int, width: Int) {
        
        // Finish initializing the tileset
        self.currentTileset.cleanAndSetSource(source)
        self.currentTileset.height = height
        self.currentTileset.width = width
        
        var rows = CGFloat(height - (2 * self.currentTileset.margin)) / CGFloat(self.currentTileset.tileHeight + self.currentTileset.spacing)
        var columns = CGFloat(width - (2 * self.currentTileset.margin)) / CGFloat(self.currentTileset.tileWidth + self.currentTileset.spacing)
        
        rows = ceil(rows)
        columns = ceil(columns)
        
        self.currentTileset.rows = Int(rows)
        self.currentTileset.columns = Int(columns)
        
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
        - parameter tmxX: The TMX x-coordinate of the object on the layer.
        - parameter tmxY: The TMX y-coordinage of the object on the layer.
        - parameter width: The width of the object.
        - parameter height: The height of the object.

    */
    func addActorToLayer(type: String, gid: Int, tmxX: CGFloat, tmxY: CGFloat, width: Int, height: Int) {
        
        let actorSprite = convertGidToTexture(gid)
        let actor = Actor(type: type, texture: actorSprite)
        
        // Convert the coordinates from TMX to SpriteKit coordinates
        let x = tmxX
        let y = self.currentLayerSize.height - tmxY
        
        self.map.addActorToLayer(self.currentLayer, actor: actor, x: x, y: y)
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
        self.currentLayerSize = CGSizeMake(CGFloat(widthInTiles * self.map.getTileWidth()), CGFloat(heightInTiles * self.map.getTileHeight()))
        self.currentLayer++
    }
    
    /**

        Adds a tile to the current layer being built
        using the texture associated with the specified
        GID.

        - parameter gid: The GID of the texture to use for the tile being added.
    */
    func addTileToLayer(gid: Int) {
        
        let tileTexture = convertGidToTexture(gid)
        let tile = SKSpriteNode(texture: tileTexture)
        
        self.map.addNextTileToLayer(self.currentLayer, tile: tile)
    }
    
    /**

        Creates an SKTexture from the specified GID.

        - parameter gid: The GID of the texture.
    
        - returns: An SKTexture loaded with the texture associated with the specified GID.
    */
    private func convertGidToTexture(gid: Int) -> SKTexture? {
        
        var texture: SKTexture? = nil
        
        // If GID isn't mapped, assume it's an empty tile (i.e. GID zero)
        if let tilesetAndNumber = self.tilesetDict[gid] {
            
            let tileset = tilesetAndNumber.tileset
            let tileNumber = tilesetAndNumber.tileNumber
            
            // Convert the tile number into a row/column position
            let row = tileset.rows - 1 - tileNumber / tileset.columns
            let column = tileNumber % tileset.columns
            
            let tileSize = CGSizeMake(CGFloat(tileset.tileWidth), CGFloat(tileset.tileHeight))
            let spacing = tileset.spacing
            let margin = tileset.margin
            
            texture = SpriteLoader.getSpriteTexture(tileset.source, spriteSize: tileSize, column: column, row: row, spacing: spacing, margin: margin)
        }
        
        return texture
    }
}
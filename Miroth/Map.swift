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
    
    private var player: PlayerEntity! = nil
    
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
     
        - parameter widthInTiles: The width of the map in tiles.
        - parameter heightInTiles: The height of the map in tiles.
        - parameter tileHeight: The height of a single tile.
        - parameter tileWidth: The width of a single tile.
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

        - parameter layer: The layer being added to the map.
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
    
    /**

        Adds the SKSpriteNode to the next tile position in the
        specified layer (tiles are added to rows from left to right
        moving to the next row after the previous is filled).

        - parameter layerNumber: The index of the layer to add the tile to.
        - parameter tile: The tile to add to the layer.
    */
    func addNextTileToLayer(layerNumber: Int, tile: SKSpriteNode) {
        
        self.layers[layerNumber].addNextTile(tile)
    }
    
    // TODO This should be turned into an object factory...
    func addActorToLayer(layerNumber: Int, actor: Actor, x: CGFloat, y: CGFloat) {
        
        switch actor.getType() {
            
        case "Blocked":
            
            // Blockers should be transparent
            actor.texture = nil
            self.layers[layerNumber].addActor(actor, x: x, y: y)
            
        case "Spawn:Player":
            
            // Create a new player
            self.player = PlayerEntity()
            self.player.layer = self.layers[layerNumber]
            self.layers[layerNumber].addActor(self.player!, x: x, y: y)
            
        case "Spawn:Slime":
            
            // Create a new slime
            let slime = SlimeEntity()
            self.layers[layerNumber].addActor(slime, x: x, y: y)
            
        default:
            break
        }
    }
    
    /**

        Checks for collisions in each layer and informs
        any collidables of collisions they are involved in.
    */
    func checkForAndNotifyOfCollisions() {
        
        for layer in self.layers {
            
            layer.checkForAndNotifyOfCollisions()
        }
    }
}

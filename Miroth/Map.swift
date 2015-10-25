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
    
    // Actual tile size
    var actualTileSize: CGSize {
        get {
            return CGSizeMake(self.size.width / CGFloat(widthInTiles), self.size.height / CGFloat(heightInTiles))
        }
    }

    // The set of layers that make up this map
    private var layers: [Layer]? = []
    
    /**
        Creates a new Map with the specified
        width and height.
    
        :param: width The width of the map.
        :param: height The height of the map.
    */
    convenience init(viewSize: CGSize, width: Int, height: Int, tileHeight: Int, tileWidth: Int) {
        self.init()
        self.size = viewSize
        self.tileHeight = tileHeight
        self.tileWidth = tileWidth
        self.widthInTiles = Int(self.size.width) / self.tileWidth
        self.heightInTiles = Int(self.size.height) / self.tileHeight
    }
    
    // Adds a new layer to the map on top of previous layers
    func addLayer(layer: Layer) {
        
        layer.zPosition = CGFloat(self.layers!.count)
        layer.position = CGPointMake(0, 0)
        layer.size = self.size
        
        self.addChild(layer)
        self.layers!.append(layer)
    }
}

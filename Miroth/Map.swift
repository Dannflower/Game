//
//  Map.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/30/15.
//  Copyright © 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class Map: SKSpriteNode {
    
    var tileHeight: Int? = nil
    var tileWidth: Int? = nil
    var layers: [Layer]? = []
    
    /**
        Creates a new Map with the specified
        width and height.
    
        :param: width The width of the map.
        :param: height The height of the map.
    */
    convenience init(width: Int, height: Int, tileHeight: Int, tileWidth: Int) {
        self.init()
        self.size = CGSizeMake(CGFloat(width), CGFloat(height))
        self.tileHeight = tileHeight
        self.tileWidth = tileWidth
    }
    
    func addLayer(layer: Layer) {
        
        self.layers!.append(layer)
    }
}

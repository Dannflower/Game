//
//  TmxConstants.swift
//  Miroth
//
//  Created by Eric Ostrowski on 10/25/15.
//  Copyright © 2015 Eric Ostrowski. All rights reserved.
//

import Foundation

struct TmxConstants {
    
    struct Element {
        
        static let MAP = "map"
        static let TILESET = "tileset"
        static let IMAGE = "image"
        static let LAYER = "layer"
        static let DATA = "data"
        static let TILE = "tile"
    }

    struct Attribute {
        
        static let WIDTH = "width"
        static let HEIGHT = "height"
        static let TILE_HEIGHT = "tileheight"
        static let TILE_WIDTH = "tilewidth"
        static let NAME = "name"
        static let FIRST_GID = "firstgid"
        static let TILE_COUNT = "tilecount"
        static let SOURCE = "source"
        static let GID = "gid"
    }
}


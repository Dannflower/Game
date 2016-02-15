//
//  Tileset.swift
//  Miroth
//
//  Created by Eric Ostrowski on 10/2/15.
//  Copyright © 2015 Eric Ostrowski. All rights reserved.
//

import Foundation

class Tileset {
    
    var name: String = ""
    var source: String = ""
    var firstGid: Int = 0
    var lastGid: Int = 0
    var gidRange: Range<Int> {
        get {
            return firstGid..<lastGid
        }
    }
    var height: Int = 0
    var width: Int = 0
    var tileHeight: Int = 0
    var tileWidth: Int = 0
    var spacing: Int = 0
    var margin: Int = 0
    var rows: Int = 0
    var columns: Int = 0
    
    convenience init(name: String, tileHeight: Int, tileWidth: Int, firstGid: Int, lastGid: Int, spacing: Int, margin: Int) {
        
        self.init()
        
        self.name = name
        self.tileHeight = tileHeight
        self.tileWidth = tileWidth
        self.spacing = spacing
        self.margin = margin
        self.firstGid = firstGid
        self.lastGid = lastGid
    }
    
    /**
        
        Cleans the TMX formatted file path and sets
        it as this Tilesets source file (source image
        must be included and indexed in Images.xcassets).

        - parameter sourcePath: The file path of the source file as provided by TMX.
    */
    func cleanAndSetSource(sourcePath: String) {
        
        let pathComponents = sourcePath.componentsSeparatedByString("/")
        let fileNameComponents = pathComponents.last!.componentsSeparatedByString(".")
        
        self.source = fileNameComponents.first!
    }
}
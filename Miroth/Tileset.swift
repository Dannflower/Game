//
//  Tileset.swift
//  Miroth
//
//  Created by Eric Ostrowski on 10/2/15.
//  Copyright © 2015 Eric Ostrowski. All rights reserved.
//

import Foundation

class Tileset {
    
    var name: String?
    var source: String?
    var firstGid: Int?
    var lastGid: Int?
    var gidRange: Range<Int> {
        get {
            return firstGid!..<lastGid!
        }
    }
    var height: Int?
    var width: Int?
    var tileHeight: Int?
    var tileWidth: Int?
    var rows: Int {
        get {
            return height! / tileHeight!
        }
    }
    var columns: Int {
        get {
            return width! / tileWidth!
        }
    }
    
    convenience init(name: String, tileHeight: Int, tileWidth: Int, firstGid: Int, lastGid: Int) {
        
        self.init()
        
        self.name = name
        self.tileHeight = tileHeight
        self.tileWidth = tileWidth
        self.firstGid = firstGid
        self.lastGid = lastGid
    }
    
    func cleanAndSetSource(sourcePath: String) {
        
        //TODO: Temp fix for cleaning up asset names
        let nameStartIndex = sourcePath.rangeOfString("imageset/")!.endIndex
        let nameEndIndex = sourcePath.rangeOfString(".png")!.startIndex
        
        self.source = sourcePath.substringWithRange(nameStartIndex..<nameEndIndex)
    }
}
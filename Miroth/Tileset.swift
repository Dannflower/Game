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
    var rows: Int {
        get {
            return height / tileHeight
        }
    }
    var columns: Int {
        get {
            return width / tileWidth
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
    
    // TODO: This should use NSBundle.mainBundle().URLForResource("filename", withExtension: ".png")
    func cleanAndSetSource(sourcePath: String) {
        
        let nameStartIndex = sourcePath.rangeOfString("imageset/")!.endIndex
        let nameEndIndex = sourcePath.rangeOfString(".png")!.startIndex
        
        self.source = sourcePath.substringWithRange(nameStartIndex..<nameEndIndex)
    }
}
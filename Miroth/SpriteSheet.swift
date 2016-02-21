//
//  SpriteSheet.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/26/15.
//  Copyright (c) 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class SpriteSheet {
    
    private let texture: SKTexture
    private let rows: Int
    private let columns: Int
    
    private var margin: CGFloat = 0
    private var spacing: CGFloat = 0
    private var firstGid: Int = 0
    private var lastGid: Int = 0
    private var spriteSize: CGSize
    
    var gidRange: Range<Int> {
        get {
            return firstGid..<lastGid
        }
    }
    
    /**
        
        Creates a new SpriteSheet using the specified texture and properties.

        - parameter texture: The sprite sheet texture.
        - parameter spriteSize: The size of a sprite in the sprite sheet.
        - parameter spacing: The spacing in pixels between sprites in the sprite sheet.
        - parameter margin: The margin between the edge of the sprite sheet and the actual sprites.
    */
    init(texture: SKTexture, spriteSize: CGSize, spacing: Int, margin: Int, firstGid: Int, lastGid: Int) {
        
        self.texture = texture
        self.spacing = CGFloat(spacing)
        self.margin = CGFloat(margin)
        self.spriteSize = spriteSize
        
        let tempRows = (self.texture.size().height - 2 * self.margin) / (self.spriteSize.height + self.spacing)
        let tempColumns = (self.texture.size().width - 2 * self.margin) / (self.spriteSize.width + self.spacing)
        
        // Round up for tilesets with spacing
        self.rows = Int(ceil(tempRows))
        self.columns = Int(ceil(tempColumns))
        self.firstGid = firstGid
        self.lastGid = lastGid
    }
    
    /**

        Returns the row count of this SpriteSheet.

        - returns: The row count of this SpriteSheet.
    */
    func getRows() -> Int {
        
        return self.rows
    }
    
    /**

        Returns the column count of this SpriteSheet.

        - returns: The column count of this SpriteSheet.
    */
    func getColumns() -> Int {
        
        return self.columns
    }
    
    /**

        Returns the texture at the specified row and column
        (the first sprite is located at the lower-left of the sprite sheet).

        - parameter column: The column of the sprite.
        - parameter row: The row of the sprite.

        - returns: The texture at the specified row and column.
    */
    func textureForColumn(column: Int, row: Int) -> SKTexture? {
        
        if !(0...self.rows ~= row && 0...self.columns ~= column) {
            
            //location is out of bounds
            return nil
        }
        
        var textureRect = CGRect(
            x: self.margin + CGFloat(column) * (self.spriteSize.width + self.spacing),
            y: self.margin + CGFloat(row) * (self.spriteSize.height + self.spacing),
            width: self.spriteSize.width,
            height: self.spriteSize.height)
        
        textureRect = CGRect(
            x: textureRect.origin.x / self.texture.size().width,
            y: textureRect.origin.y / self.texture.size().height,
            width: textureRect.size.width / self.texture.size().width,
            height: textureRect.size.height / self.texture.size().height)
        
        let texture = SKTexture(rect: textureRect, inTexture: self.texture)
            
        texture.filteringMode = SKTextureFilteringMode.Nearest
        
        return texture
    }
}

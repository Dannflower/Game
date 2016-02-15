//
//  SpriteSheet.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/26/15.
//  Copyright (c) 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class SpriteSheet {
    
    let texture: SKTexture
    let rows: Int
    let columns: Int
    var margin: CGFloat = 0
    var spacing: CGFloat = 0
    
    var frameSize: CGSize {
        
        return CGSize(
            width: 16.0,
            height: 16.0)
    }
    
    init(texture: SKTexture, rows: Int, columns: Int, spacing: CGFloat, margin: CGFloat) {
        
        self.texture=texture
        self.rows=rows
        self.columns=columns
        self.spacing=spacing
        self.margin=margin
        
    }

    convenience init(texture: SKTexture, rows: Int, columns: Int, spacing: Int, margin: Int) {
        
        self.init(texture: texture, rows: rows, columns: columns, spacing: CGFloat(spacing), margin: CGFloat(margin))
    }
    
    func textureForColumn(column: Int, row: Int) -> SKTexture? {
        
        if !(0...self.rows ~= row && 0...self.columns ~= column) {
            
            //location is out of bounds
            return nil
        }
        
        var textureRect = CGRect(
            x: self.margin + CGFloat(column) * (self.frameSize.width + self.spacing),
            y: self.margin + CGFloat(row) * (self.frameSize.height + self.spacing),
            width: self.frameSize.width,
            height: self.frameSize.height)
        
        print(textureRect)
        print(self.texture.size())
        
        textureRect = CGRect(
            x: textureRect.origin.x / self.texture.size().width,
            y: textureRect.origin.y / self.texture.size().height,
            width: textureRect.size.width / self.texture.size().width,
            height: textureRect.size.height / self.texture.size().height)
        
        print(textureRect)
        
        return SKTexture(rect: textureRect, inTexture: self.texture)
    }
    
}

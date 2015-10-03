//
//  SpriteLoader.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/26/15.
//  Copyright © 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class SpriteLoader {
    
    enum Sprite {
        
        case HumanKnight
        
        case Tree
    }
    
    private static var spriteSheets = [String : SpriteSheet]()
    
    
    class func getSpriteTexture(sprite: Sprite) -> SKTexture? {
        
        switch sprite {
            
        case .HumanKnight:
            return getSpriteTexture("Player0", column: 1, row: 11)
            
        case .Tree:
            return getSpriteTexture("Tree0", column: 3, row: 32)
        }
    }
    
    class func getSpriteTexture(spriteSheetName: String, column: Int, row: Int) -> SKTexture? {
        
        var spriteSheet: SpriteSheet? = spriteSheets[spriteSheetName]
        
        // If the sprite sheet doesn't exist, load it
        if(spriteSheet == nil) {
            loadSpriteSheet(spriteSheetName)
            spriteSheet = spriteSheets[spriteSheetName]
        }
        
        let spriteTexture = spriteSheet?.textureForColumn(column, row: row)
        spriteTexture?.filteringMode = SKTextureFilteringMode.Nearest
        
        // Return the requested sprite or nil if it couldn't be obtained
        return spriteTexture
    }
    
    private static func loadSpriteSheet(name: String) {
        
        let spriteSheetTexture = SKTexture(imageNamed: name)
        
        let rows = Int(spriteSheetTexture.size().height / 16)
        let columns = Int(spriteSheetTexture.size().width / 16)
        
        let spriteSheet = SpriteSheet(texture: spriteSheetTexture, rows: rows, columns: columns)
        
        spriteSheets[name] = spriteSheet
    }
}

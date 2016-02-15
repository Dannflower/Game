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
        
        case AdventurerMale
        
        case Blocker
    }
    
    private static var spriteSheets = [String : SpriteSheet]()
    
    
    class func getSpriteTexture(sprite: Sprite) -> SKTexture? {
        
        switch sprite {
            
        case .HumanKnight:
            return getSpriteTexture("Player0", spriteSize: CGSizeMake(16.0, 16.0), column: 1, row: 11, spacing: 0, margin: 0)
            
        case .AdventurerMale:
            return getSpriteTexture("adventurer_m_front", spriteSize: CGSizeMake(16.0, 16.0), column: 0, row: 3, spacing: 2, margin: 1)
            
        case .Blocker:
            return getSpriteTexture("Blocked Tile", spriteSize: CGSizeMake(16.0, 16.0), column: 0, row: 0, spacing: 0, margin: 0)
        }
    }
    
    class func getSpriteTexture(spriteSheetName: String, spriteSize: CGSize, column: Int, row: Int, spacing: Int, margin: Int) -> SKTexture? {
        
        var spriteSheet: SpriteSheet? = spriteSheets[spriteSheetName]
        
        // If the sprite sheet doesn't exist, load it
        if(spriteSheet == nil) {
            
            loadSpriteSheet(spriteSheetName, spriteSize: spriteSize, spacing: spacing, margin: margin)
            spriteSheet = spriteSheets[spriteSheetName]
        }
        
        let spriteTexture = spriteSheet?.textureForColumn(column, row: row)
        spriteTexture?.filteringMode = SKTextureFilteringMode.Nearest
        
        // Return the requested sprite or nil if it couldn't be obtained
        return spriteTexture
    }
    
    private static func loadSpriteSheet(name: String, spriteSize: CGSize, spacing: Int, margin: Int) {
        
        let spriteSheetTexture = SKTexture(imageNamed: name)
        // TODO Texture size should not be hard-coded
        var rows = (spriteSheetTexture.size().height - CGFloat(2 * margin)) / (spriteSize.height + CGFloat(spacing))
        var columns = (spriteSheetTexture.size().width - CGFloat(2 * margin)) / (spriteSize.width + CGFloat(spacing))
        
        rows = ceil(rows)
        columns = ceil(columns)
        
        let spriteSheet = SpriteSheet(texture: spriteSheetTexture, rows: Int(rows), columns: Int(columns), spacing: spacing, margin: margin)
        
        spriteSheets[name] = spriteSheet
    }
}

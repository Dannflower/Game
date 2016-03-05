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
        
        case SwordUp
        
        case Blocker
    }
    
    private static var spriteSheets = [String : SpriteSheet]()
    
    
    /**
        
        Returns the specified pre-configured texture.

        - parameter sprite: The desired sprite.

        - returns: The specified sprite.
    */
    class func getSpriteTexture(sprite: Sprite) -> SKTexture? {
        
        switch sprite {
            
        case .HumanKnight:
            return getSpriteTexture("Player0", spriteSize: CGSizeMake(16.0, 16.0), column: 1, row: 11, spacing: 0, margin: 0)
            
        case .AdventurerMale:
            return getSpriteTexture("adventurer_m_front", spriteSize: CGSizeMake(16.0, 16.0), column: 0, row: 3, spacing: 2, margin: 1)
            
        case .SwordUp:
            return getSpriteTexture("sword attack", spriteSize: CGSizeMake(16.0, 16.0), column: 3, row: 0, spacing: 0, margin: 0)
            
        case .Blocker:
            return getSpriteTexture("Blocked Tile", spriteSize: CGSizeMake(16.0, 16.0), column: 0, row: 0, spacing: 0, margin: 0)
        }
    }
    
    /**
     
        Returns a SKTexture based on the source image and specified properties, loading the SpriteSheet if necessary.
     
        - parameter spriteSheetSourceImage: The file name of the source image or its path.
        - parameter spriteSize: The size of a sprite in the sprite sheet.
        - parameter spacing: The spacing in pixels between each sprite in the sprite sheet.
        - parameter margin: The margin between the edge of the sprite sheet and the actual sprites.
     
        - returns: The requested SpriteSheet.
     */
    class func getSpriteTexture(spriteSheetSourceImage: String, spriteSize: CGSize, column: Int, row: Int, spacing: Int, margin: Int) -> SKTexture? {
        
        let spriteSheet = loadSpriteSheet(spriteSheetSourceImage, spriteSize: spriteSize, spacing: spacing, margin: margin, firstGid: 0, lastGid: 0)
        
        let spriteTexture = spriteSheet.textureForColumn(column, row: row)
        
        // Return the requested sprite or nil if it couldn't be obtained
        return spriteTexture
    }
    
    /**
        
        Returns an SKTexture based on the source image and specified properties mirrored on the X-axis, loading the SpriteSheet if necessary.

        - parameter spriteSheetSourceImage: The file name of the source image or its path.
        - parameter spriteSize: The size of a sprite in the sprite sheet.
        - parameter spacing: The spacing in pixels between each sprite in the sprite sheet.
        - parameter margin: The margin between the edge of the sprite sheet and the actual sprites.

        - returns: The requested SKTexture mirrored on the X-axis.
    */
    class func getXAxisMirroredSpriteTexture(spriteSheetSourceImage: String, spriteSize: CGSize, column: Int, row: Int, spacing: Int, margin: Int) -> SKTexture? {
        
        let spriteSheet = loadSpriteSheet(spriteSheetSourceImage, spriteSize: spriteSize, spacing: spacing, margin: margin, firstGid: 0, lastGid: 0)
        let spriteTexture = spriteSheet.textureForColumn(column, row: row)
        
        let node = SKSpriteNode(texture: spriteTexture)
        let view = SKView()
        
        // Mirror the texture on the X-axis
        node.xScale = node.xScale * -1
        
        let texture = view.textureFromNode(node)
        
        // The View returns a linearly filtered texture
        texture!.filteringMode = .Nearest
        
        return texture
    }
    
    /**
        
        Returns a SpriteSheet based on the source image and specified properties, loading it if necessary.

        - parameter spriteSheetSourceImage: The file name of the source image or its path.
        - parameter spriteSize: The size of a sprite in the sprite sheet.
        - parameter spacing: The spacing in pixels between each sprite in the sprite sheet.
        - parameter margin: The margin between the edge of the sprite sheet and the actual sprites.

        - returns: The requested SpriteSheet.
    */
    class func getSpriteSheet(spriteSheetSourceImage: String, spriteSize: CGSize, spacing: Int, margin: Int, firstGid: Int, lastGid: Int) -> SpriteSheet {
        
        return loadSpriteSheet(spriteSheetSourceImage, spriteSize: spriteSize, spacing: spacing, margin: margin, firstGid: firstGid, lastGid: lastGid)
    }
    
    /**

        Loads a new SpriteSheet from the source image using the specified properties.

        - parameter spriteSheetSourceImage: The file name of the source image or its path.
        - parameter spriteSize: The size of a sprite in the SpriteSheet.
        - parameter spacing: The spacing in pixels between each sprite in the sprite sheet.
        - parameter margin: The margin between the edge of the sprite sheet and the actual sprites.

        - returns: The requested SpriteSheet.
    */
    private static func loadSpriteSheet(spriteSheetSourceImage: String, spriteSize: CGSize, spacing: Int, margin: Int, firstGid: Int, lastGid: Int) -> SpriteSheet {
        
        var spriteSheet: SpriteSheet? = spriteSheets[spriteSheetSourceImage]
        
        // If the sprite sheet doesn't exist, load it
        if(spriteSheet == nil) {
            
            let spriteSheetTexture = createSourceImageTexture(spriteSheetSourceImage)
            
            spriteSheet = SpriteSheet(texture: spriteSheetTexture!, spriteSize: spriteSize, spacing: spacing, margin: margin, firstGid: firstGid, lastGid: lastGid)
            
            spriteSheets[spriteSheetSourceImage] = spriteSheet
        }
        
        return spriteSheet!
    }
    
    /**
     
        Cleans the TMX formatted file path and sets
        it as this Tilesets source file (source image
        must be included and indexed in Images.xcassets).
     
        - parameter sourcePath: The file path of the source file as provided by TMX.
     */
    private static func createSourceImageTexture(sourcePath: String) -> SKTexture? {
        
        let pathComponents = sourcePath.componentsSeparatedByString("/")
        let fileNameComponents = pathComponents.last!.componentsSeparatedByString(".")
        
        return SKTexture(imageNamed: fileNameComponents.first!)
    }
}

//
//  MapLoader.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/29/15.
//  Copyright © 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class MapLoader: NSObject, NSXMLParserDelegate {
    
    // Elements
    private let MAP_ELEMENT = "map"
    private let TILESET_ELEMENT = "tileset"
    private let IMAGE_ELEMENT = "image"
    private let LAYER_ELEMENT = "layer"
    private let DATA_ELEMENT = "data"
    private let TILE_ELEMENT = "tile"
    
    // Attributes
    private let WIDTH_ATTRIBUTE = "width"
    private let HEIGHT_ATTRIBUTE = "height"
    private let TILE_HEIGHT_ATTRIBUTE = "tileheight"
    private let TILE_WIDTH_ATTRIBUTE = "tilewidth"
    private let NAME_ATTRIBUTE = "name"
    private let FIRST_GID_ATTRIBUTE = "firstgid"
    private let TILE_COUNT_ATTRIBUTE = "tilecount"
    private let SOURCE_ATTRIBUTE = "source"
    private let GID_ATTRIBUTE = "gid"
    
    // Range of tile GIDs that map to the current tileset
    var tilesetGidRange: Range<Int>? = nil
    
    // Maps tile GID to tileset it belongs to and its place in the tileset
    var tilesetDict: [Int : (tileset: Tileset, tileNumber:Int)] = [:]
    
    // Maps a tileset by name to its dimensions
    var tilesetDimensionsDict: [String : (rows: Int, columns: Int)] = [:]
    
    // The current map
    var map: Map? = nil
    
    // The current layer
    var layer: Layer? = nil
    
    // The current tileset
    var tileset: Tileset? = nil
    
    func loadMap(mapPath: String) -> Map {
        
        if let fileStream = NSInputStream(fileAtPath: mapPath) {
            
            let parser = NSXMLParser(stream: fileStream)
            parser.delegate = self
            parser.parse()
        
        } else {
            
            print("Error loading map at: \(mapPath)")
        }
        
        return map!
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    
        switch elementName {
            
        case LAYER_ELEMENT:
            
            print("Finished layer: \(self.layer!.name)")
            
            map!.addLayer(layer!)
            
        default:
            // Do nothing
            return
        }
    }
    
    func parser(parser: NSXMLParser, didEndMappingPrefix prefix: String) {}
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        switch elementName {
        
        case MAP_ELEMENT:
            
            print("Map")
            
            // Create a new map
            map = Map(
                width: Int(attributeDict[WIDTH_ATTRIBUTE]!)!,
                height: Int(attributeDict[HEIGHT_ATTRIBUTE]!)!,
                tileHeight: Int(attributeDict[TILE_HEIGHT_ATTRIBUTE]!)!,
                tileWidth: Int(attributeDict[TILE_WIDTH_ATTRIBUTE]!)!)
            
        case TILESET_ELEMENT:
            
            print("Tileset")
            
            // Determine the GID range for the tileset
            let firstGid = Int(attributeDict[FIRST_GID_ATTRIBUTE]!)!
            let lastGid = firstGid + Int(attributeDict[TILE_COUNT_ATTRIBUTE]!)!
            
            //Create a new tileset
            tileset = Tileset(
                name: attributeDict[NAME_ATTRIBUTE]!,
                tileHeight: Int(attributeDict[TILE_HEIGHT_ATTRIBUTE]!)!,
                tileWidth: Int(attributeDict[TILE_WIDTH_ATTRIBUTE]!)!,
                firstGid: firstGid,
                lastGid: lastGid)
            
            
        case IMAGE_ELEMENT:
            
            print("Image")
            
            // Finish initializing the tileset
            tileset!.cleanAndSetSource(attributeDict[SOURCE_ATTRIBUTE]!)
            tileset!.height = Int(attributeDict[HEIGHT_ATTRIBUTE]!)!
            tileset!.width = Int(attributeDict[WIDTH_ATTRIBUTE]!)!
            
            var tileNumber = 0
            
            // Assign a tileset and tile number to each GID
            for gid in tileset!.gidRange {
                
                print("GID: \(gid) Tileset: \(tileset!.source) Tile Number: \(tileNumber)")
                tilesetDict[gid] = (tileset!, tileNumber++)
            }
            
        case LAYER_ELEMENT:
            
            print("Layer")
            
            // Create a new layer
            layer = Layer(
                name: attributeDict[NAME_ATTRIBUTE]!,
                widthInTiles: Int(attributeDict[WIDTH_ATTRIBUTE]!)!,
                heightInTiles: Int(attributeDict[HEIGHT_ATTRIBUTE]!)!,
                tileHeight: map!.tileHeight!,
                tileWidth: map!.tileWidth!)
        
        case DATA_ELEMENT:
        
            print("Data")
            
        case TILE_ELEMENT:
            
            print("Tile")
            
            // Create a new tile
            let tile = convertGidToSpriteNode(Int(attributeDict[GID_ATTRIBUTE]!)!)
            
            layer!.addNextTile(tile!)
            
        default:
            
            print("Unknown")
        }
    }
    
    func parser(parser: NSXMLParser, didStartMappingPrefix prefix: String, toURI namespaceURI: String) {}
    
    func parser(parser: NSXMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?) {}
    
    func parser(parser: NSXMLParser, foundCDATA CDATABlock: NSData) {}
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {}
    
    func parser(parser: NSXMLParser, foundComment comment: String) {}
    
    func parser(parser: NSXMLParser, foundElementDeclarationWithName elementName: String, model: String) {}
    
    func parser(parser: NSXMLParser, foundExternalEntityDeclarationWithName name: String, publicID: String?, systemID: String?) {}
    
    func parser(parser: NSXMLParser, foundIgnorableWhitespace whitespaceString: String) {}
    
    func parser(parser: NSXMLParser, foundInternalEntityDeclarationWithName name: String, value: String?) {}
    
    func parser(parser: NSXMLParser, foundNotationDeclarationWithName name: String, publicID: String?, systemID: String?) {}
    
    func parser(parser: NSXMLParser, foundProcessingInstructionWithTarget target: String, data: String?) {}
    
    func parser(parser: NSXMLParser, foundUnparsedEntityDeclarationWithName name: String, publicID: String?, systemID: String?, notationName: String?) {}
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {}
    
    func parser(parser: NSXMLParser, resolveExternalEntityName name: String, systemID: String?) -> NSData? { return nil }
    
    func parser(parser: NSXMLParser, validationErrorOccurred validationError: NSError) {}
    
    func parserDidEndDocument(parser: NSXMLParser) {}
    
    func parserDidStartDocument(parser: NSXMLParser) {}
    
    // Given a GID, create a sprite node with the texture
    // of the tile that corresponds to the GID
    func convertGidToSpriteNode(gid: Int) -> SKSpriteNode? {
        
        let spriteNode = SKSpriteNode()
        
        // If GID isn't mapped, assume it's an empty tile (i.e. GID zero)
        if let tilesetAndNumber = self.tilesetDict[gid] {
            
            let tileset = tilesetAndNumber.tileset
            let tileNumber = tilesetAndNumber.tileNumber
            
            let row = tileNumber / tileset.rows
            let column = tileNumber % tileset.columns
            
            let texture = SpriteLoader.getSpriteTexture(tileset.source!, column: column, row: row)
            
            spriteNode.texture = texture
            
        }
        
        return spriteNode
    }
}
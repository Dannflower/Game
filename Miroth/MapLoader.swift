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
    private let FIRST_GID_ATTRIBUTE = "firstgid"
    private let TILE_COUNT_ATTRIBUTE = "tilecount"
    private let SOURCE_ATTRIBUTE = "source"
    private let GID_ATTRIBUTE = "gid"
    
    
    // Maps tile GID to tileset it belongs to and its place in the tileset
    var tilesetDict: [Int : (String, Int)] = [:]
    // Range of tile GIDs that map to the next tileset found
    var tilesetGidRange: Range<Int>? = nil
    
    func loadMap(mapPath: String) {
        
        if let fileStream = NSInputStream(fileAtPath: mapPath) {
            
            let parser = NSXMLParser(stream: fileStream)
            parser.delegate = self
            parser.parse()
        
        } else {
            
            print("Error loading map at: \(mapPath)")
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {}
    
    func parser(parser: NSXMLParser, didEndMappingPrefix prefix: String) {}
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        var tileNumber = 0
        var map: Map? = nil
        var layer: Layer? = nil
        
        switch elementName {
        
        case MAP_ELEMENT:
            
            print("Map")
            
            // Create a new map
            map = Map(width: Int(attributeDict[WIDTH_ATTRIBUTE]!)!, height: Int(attributeDict[HEIGHT_ATTRIBUTE]!)!)
            
        case TILESET_ELEMENT:
            
            print("Tileset")
            
            // Determine the GID range for the tileset
            let gidRangeStart = Int(attributeDict[FIRST_GID_ATTRIBUTE]!)!
            let gidRangeEnd = gidRangeStart + Int(attributeDict[TILE_COUNT_ATTRIBUTE]!)!
            tilesetGidRange = gidRangeStart..<gidRangeEnd
            
            print("Tileset GID range: \(tilesetGidRange)")
            
        case IMAGE_ELEMENT:
            
            print("Image")
            
            // Get the name of the tileset image
            let imagePath = attributeDict[SOURCE_ATTRIBUTE]!
            let nameStartIndex = imagePath.rangeOfString("imageset/")!.endIndex
            let imageName = imagePath.substringFromIndex(nameStartIndex)
            
            // Assign the tileset name to each GID it corresponds to
            for index in tilesetGidRange! {
                
                print("GID: \(index) Tileset: \(imageName) Tile Number: \(tileNumber)")
                tilesetDict[index] = (imageName, tileNumber++)
            }
            
        case LAYER_ELEMENT:
            
            print("Layer")
            
            // Create a new layer
            layer = Layer(width: Int(attributeDict[WIDTH_ATTRIBUTE]!)!, height: Int(attributeDict[HEIGHT_ATTRIBUTE]!)!)
            
            
        case TILE_ELEMENT:
            
            print("Tile")
            
            // Create a new tile
            
            
        default:
            // Do nothing
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
}
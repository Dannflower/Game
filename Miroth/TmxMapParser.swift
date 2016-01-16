//
//  MapLoader.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/29/15.
//  Copyright © 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class TmxMapParser: NSObject, NSXMLParserDelegate {
    
    // The current map
    var map: Map! = nil
    
    // Indicates if the map file contained an error
    var hasMapError: Bool = false
    
    var mapBuilder: MapBuilder! = nil
    
    // Errors
    enum MapLoaderError: ErrorType {
        
        case MissingAttribute(attributeName: String)
        case MalformedAttribute(attributeName: String)
    }
    
    // Parses the map
    func parseMap(mapPath: String, viewSize: CGSize) -> Map? {
        
        self.mapBuilder = MapBuilder(mapViewSize: viewSize)
        
        if let fileStream = NSInputStream(fileAtPath: mapPath) {
            
            let parser = NSXMLParser(stream: fileStream)
            parser.delegate = self
            parser.parse()
        
        } else {
            
            print("Error loading map at: \(mapPath)")
            hasMapError = true
        }
        
        // If an error was found, consider the map invalid
        if hasMapError {
            
            return nil
        }
        
        // Otherwise, return it as is
        return map
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        do {
        
            switch elementName {
            
                
            case TmxConstants.Element.MAP:
            
                print("Map")
            
                // Collect attributes from dictionary
                guard let widthInTiles = attributeDict[TmxConstants.Attribute.WIDTH] else {
                
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.WIDTH)
                }
            
                guard let heightInTiles = attributeDict[TmxConstants.Attribute.HEIGHT] else {
                
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.HEIGHT)
                }
            
                guard let tileHeight = attributeDict[TmxConstants.Attribute.TILE_HEIGHT] else {
                
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.TILE_HEIGHT)
                }
            
                guard let tileWidth = attributeDict[TmxConstants.Attribute.TILE_WIDTH] else {
                
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.TILE_WIDTH)
                }
            
                // Convert attribute strings to integers
                guard let widthInTilesInt = Int(widthInTiles) else {
                
                    throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.WIDTH)
                }
            
                guard let heightInTilesInt = Int(heightInTiles) else {
                    
                    throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.HEIGHT)
                }
                
                guard let tileHeightInt = Int(tileHeight) else {
                    
                    throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.TILE_HEIGHT)
                }
                
                guard let tileWidthInt = Int(tileWidth) else {
                    
                    throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.TILE_WIDTH)
                }
                
                // Start creating the map
                self.mapBuilder.createMap(widthInTilesInt, heightInTiles: heightInTilesInt, tileHeight: tileHeightInt, tileWidth: tileWidthInt)
                
                
            case TmxConstants.Element.TILESET:
                
                // Collect attributes from dictionary
                guard let name = attributeDict[TmxConstants.Attribute.NAME] else {
                    
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.NAME)
                }
                
                guard let firstGid = attributeDict[TmxConstants.Attribute.FIRST_GID] else {
                    
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.FIRST_GID)
                }
                
                guard let tileCount = attributeDict[TmxConstants.Attribute.TILE_COUNT] else {
                    
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.TILE_COUNT)
                }
                
                guard let tileHeight = attributeDict[TmxConstants.Attribute.TILE_HEIGHT] else {
                    
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.TILE_HEIGHT)
                }
                
                guard let tileWidth = attributeDict[TmxConstants.Attribute.TILE_WIDTH] else {
                    
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.TILE_WIDTH)
                }
                
                // Convert attribute strings to integers
                guard let firstGidInt = Int(firstGid) else {
                    
                    throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.FIRST_GID)
                }
                
                guard let tileCountInt = Int(tileCount) else {
                    
                    throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.TILE_COUNT)
                }
                
                guard let tileHeightInt = Int(tileHeight) else {
                    
                    throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.TILE_HEIGHT)
                }
                
                guard let tileWidthInt = Int(tileWidth) else {
                    
                    throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.TILE_WIDTH)
                }
                    
                self.mapBuilder.createTileset(name, firstGid: firstGidInt, tileCount: tileCountInt, tileHeight: tileHeightInt, tileWidth: tileWidthInt)
               
                
            case TmxConstants.Element.IMAGE:
                
                // Collect attributes from dictionary
                guard let source = attributeDict[TmxConstants.Attribute.SOURCE] else {
                    
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.SOURCE)
                }
                
                guard let height = attributeDict[TmxConstants.Attribute.HEIGHT] else {
                    
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.HEIGHT)
                }
                
                guard let width = attributeDict[TmxConstants.Attribute.WIDTH] else {
                    
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.WIDTH)
                }
                
                // Convert attribute strings to integers
                guard let heightInt = Int(height) else {
                    
                    throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.HEIGHT)
                }
                
                guard let widthInt = Int(width) else {
                    
                    throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.WIDTH)
                }
                    
                self.mapBuilder.setTilesetSource(source, height: heightInt, width: widthInt)
                
                
            case TmxConstants.Element.LAYER:
                
                // Collect attributes from dictionary
                guard let name = attributeDict[TmxConstants.Attribute.NAME] else {
                    
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.NAME)
                }
                
                guard let widthInTiles = attributeDict[TmxConstants.Attribute.WIDTH] else {
                    
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.WIDTH)
                }
                
                guard let heightInTiles = attributeDict[TmxConstants.Attribute.HEIGHT] else {
                    
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.HEIGHT)
                }
                
                // Convert attribute strings to integers
                guard let widthInTilesInt = Int(widthInTiles) else {
                    
                    throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.WIDTH)
                }
                
                guard let heightInTilesInt = Int(heightInTiles) else {
                    
                    throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.HEIGHT)
                }
                
                self.mapBuilder.createLayer(name, widthInTiles: widthInTilesInt, heightInTiles: heightInTilesInt)
            
            case TmxConstants.Element.DATA:
            
                print("Data")
                
            case TmxConstants.Element.TILE:
                
                guard let gid = attributeDict[TmxConstants.Attribute.GID] else {
                    
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.GID)
                }
                
                guard let gidInt = Int(gid) else {
                    
                    throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.GID)
                }
                
                self.mapBuilder.addTileToLayer(gidInt)
                
                
            case TmxConstants.Element.OBJECT_GROUP:
                
                print("Object group")
                
                
            case TmxConstants.Element.OBJECT:
                
                print("Object")
                
                guard let id = attributeDict[TmxConstants.Attribute.ID] else {
                    
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.ID)
                }
                
                guard let type = attributeDict[TmxConstants.Attribute.TYPE] else {
                    
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.TYPE)
                }
                
                guard let gid = attributeDict[TmxConstants.Attribute.GID] else {
                    
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.GID)
                }
                
                guard let x = attributeDict[TmxConstants.Attribute.X] else {
                    
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.X)
                }
                
                guard let y = attributeDict[TmxConstants.Attribute.Y] else {
                    
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.Y)
                }
                
                guard let width = attributeDict[TmxConstants.Attribute.WIDTH] else {
                    
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.WIDTH)
                }
                
                guard let height = attributeDict[TmxConstants.Attribute.HEIGHT] else {
                    
                    throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.HEIGHT)
                }
                
                guard let idInt = Int(id) else {
                    
                    throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.ID)
                }
                
                guard let gidInt = Int(gid) else {
                    
                    throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.GID)
                }
                
                guard let xInt = Int(x) else {
                    
                    throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.X)
                }
                
                guard let yInt = Int(y) else {
                    
                    throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.Y)
                }
                
                guard let widthInt = Int(width) else {
                    
                    throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.WIDTH)
                }
                
                guard let heightInt = Int(height) else {
                    
                    throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.HEIGHT)
                }
                
                self.mapBuilder.addObjectToLayer(idInt, type: type, gid: gidInt, x: xInt, y: yInt, width: widthInt, height: heightInt)
                
            default:
                
                print("Unknown")
            }
            
        } catch MapLoaderError.MissingAttribute(let attributeName) {
            
            print("Error loading layer! Missing attribute: \(attributeName)")
            hasMapError = true
            return
            
        } catch MapLoaderError.MalformedAttribute(let attributeName) {
            
            print("Error loading layer! Malformed attribute: \(attributeName)")
            hasMapError = true
            return
            
        } catch {
            
            print("Error loading layer!")
            hasMapError = true
            return
        }
    }
    
    // Returns the finished map
    func parserDidEndDocument(parser: NSXMLParser) {
        
        self.map = self.mapBuilder.getMap()
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {}
    
    func parser(parser: NSXMLParser, didEndMappingPrefix prefix: String) {}
    
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
    
    func parserDidStartDocument(parser: NSXMLParser) {}
}
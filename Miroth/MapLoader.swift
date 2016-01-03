//
//  MapLoader.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/29/15.
//  Copyright © 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class MapLoader: NSObject, NSXMLParserDelegate {
    
    // Range of tile GIDs that map to the current tileset
    var tilesetGidRange: Range<Int>? = nil
    
    // Maps tile GID to tileset it belongs to and its place in the tileset
    var tilesetDict: [Int : (tileset: Tileset, tileNumber:Int)] = [:]
    
    // Maps a tileset by name to its dimensions
    var tilesetDimensionsDict: [String : (rows: Int, columns: Int)] = [:]
    
    // The current map
    var map: Map! = nil
    
    // The current layer
    var layer: Layer! = nil
    
    // The current tileset
    var tileset: Tileset! = nil
    
    // Size of the view
    var viewSize: CGSize? = nil
    
    // Indicates if the map file contained an error
    var hasMapError: Bool = false
    
    // Errors
    enum MapLoaderError: ErrorType {
        
        case MissingAttribute(attributeName: String)
        case MalformedAttribute(attributeName: String)
    }
    
    func loadMap(mapPath: String, viewSize: CGSize) -> Map? {
        
        self.viewSize = viewSize
        
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
        
        switch elementName {
        
        case TmxConstants.Element.MAP:
            
            print("Map")
            
            do {
                
                try map = parseMapElement(attributeDict)
                
            } catch MapLoaderError.MissingAttribute(let attributeName) {
                
                print("Error loading map! Missing attribute: \(attributeName)")
                hasMapError = true
                return
            
            } catch {
                
                print("Error loading map!")
                hasMapError = true
                return
            }
            
        case TmxConstants.Element.TILESET:
            
            do {
                
                try tileset = parseTilesetElement(attributeDict)
                
            } catch MapLoaderError.MissingAttribute(let attributeName) {
                
                print("Error loading tileset! Missing attribute: \(attributeName)")
                hasMapError = true
                return
            
            } catch MapLoaderError.MalformedAttribute(let attributeName) {
                
                print("Error loading tileset! Malformed attribute: \(attributeName)")
                hasMapError = true
                return
            
            } catch {
                
                print("Error loading tileset!")
                hasMapError = true
                return
            }
            
        case TmxConstants.Element.IMAGE:
            
            do {
                
                try parseImageElement(attributeDict)
            
            } catch MapLoaderError.MissingAttribute(let attributeName) {
                
                print("Error loading image! Missing attribute: \(attributeName)")
                hasMapError = true
                return
                
            } catch MapLoaderError.MalformedAttribute(let attributeName) {
                
                print("Error loading image! Malformed attribute: \(attributeName)")
                hasMapError = true
                return
            
            } catch {
                
                print("Error loading image!")
                hasMapError = true
                return
            }
            
        case TmxConstants.Element.LAYER:
            
            do {
                
                try parseLayerElement(attributeDict)
                
            } catch MapLoaderError.MissingAttribute(let attributeName) {
                
                print("Error loading layer! Missing attribute: \(attributeName)")
                hasMapError = true
                return
                
            } catch MapLoaderError.MalformedAttribute(let attributeName) {
                
                print("Error loading layer! Missing attribute: \(attributeName)")
                hasMapError = true
                return
            
            } catch {
                
                print("Error loading layer!")
                hasMapError = true
                return
            }
        
        case TmxConstants.Element.DATA:
        
            print("Data")
            
        case TmxConstants.Element.TILE:
            
            // Create a new tile
            let tile = convertGidToSpriteNode(Int(attributeDict[TmxConstants.Attribute.GID]!)!)
            
            layer.addNextTile(tile!)
            
        default:
            
            print("Unknown")
        }
    }
    
    private func parseMapElement(attributeDict: [String : String]) throws -> Map {
        
        // Collect attributes from dictionary
        guard let width = attributeDict[TmxConstants.Attribute.WIDTH] else {
            
            throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.NAME)
        }
        
        guard let height = attributeDict[TmxConstants.Attribute.HEIGHT] else {
            
            throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.HEIGHT)
        }
        
        guard let tileHeight = attributeDict[TmxConstants.Attribute.TILE_HEIGHT] else {
            
            throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.TILE_HEIGHT)
        }
        
        guard let tileWidth = attributeDict[TmxConstants.Attribute.TILE_WIDTH] else {
            
            throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.TILE_WIDTH)
        }
        
        // Convert attribute strings to integers
        guard let widthInt = Int(width) else {
            
            throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.WIDTH)
        }
        
        guard let heightInt = Int(height) else {
            
            throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.HEIGHT)
        }
        
        guard let tileHeightInt = Int(tileHeight) else {
            
            throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.TILE_HEIGHT)
        }
        
        guard let tileWidthInt = Int(tileWidth) else {
            
            throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.TILE_WIDTH)
        }
        
        // Create a new map
        return Map(
            viewSize: self.viewSize!,
            widthInTiles: widthInt,
            heightInTiles: heightInt,
            tileHeight: tileHeightInt,
            tileWidth: tileWidthInt)
    }
    
    private func parseTilesetElement(attributeDict: [String : String]) throws -> Tileset {
        
        print("Tileset")
        
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
        
        // Determine the GID range for the tileset
        let lastGid = firstGidInt + tileCountInt
        
        //Create a new tileset
        return Tileset(
            name: name,
            tileHeight: tileHeightInt,
            tileWidth: tileWidthInt,
            firstGid: firstGidInt,
            lastGid: lastGid)
    }
    
    private func parseImageElement(attributeDict: [String : String]) throws {
        
        print("Image")
        
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
        
        // Finish initializing the tileset
        tileset.cleanAndSetSource(source)
        tileset.height = heightInt
        tileset.width = widthInt
        
        var tileNumber = 0
        
        // Assign a tileset and tile number to each GID
        for gid in tileset.gidRange {
            
            //print("GID: \(gid) Tileset: \(tileset.source) Tile Number: \(tileNumber)")
            tilesetDict[gid] = (tileset, tileNumber++)
        }
    }
    
    private func parseLayerElement(attributeDict: [String : String]) throws {
        
        print("Layer")
        
        // Collect attributes from dictionary
        guard let name = attributeDict[TmxConstants.Attribute.NAME] else {
            
            throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.NAME)
        }
        
        guard let widthinTiles = attributeDict[TmxConstants.Attribute.WIDTH] else {
            
            throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.WIDTH)
        }
        
        guard let heightInTiles = attributeDict[TmxConstants.Attribute.HEIGHT] else {
            
            throw MapLoaderError.MissingAttribute(attributeName: TmxConstants.Attribute.HEIGHT)
        }
        
        // Convert attribute strings to integers
        guard let widthInTilesInt = Int(widthinTiles) else {
            
            throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.WIDTH)
        }
        
        guard let heightInTilesInt = Int(heightInTiles) else {
            
            throw MapLoaderError.MalformedAttribute(attributeName: TmxConstants.Attribute.HEIGHT)
        }
        
        // Create a new layer
        layer = Layer(
            name: name,
            widthInTiles: widthInTilesInt,
            heightInTiles: heightInTilesInt)
        
        self.map.addLayer(self.layer)
    }
    
    // Given a GID, create a sprite node with the texture
    // of the tile that corresponds to the GID
    private func convertGidToSpriteNode(gid: Int) -> SKSpriteNode? {
        
        let spriteNode = SKSpriteNode()
        
        // If GID isn't mapped, assume it's an empty tile (i.e. GID zero)
        if let tilesetAndNumber = self.tilesetDict[gid] {
            
            let tileset = tilesetAndNumber.tileset
            let tileNumber = tilesetAndNumber.tileNumber
            
            let row = tileset.rows - 1 - tileNumber / tileset.columns
            let column = tileNumber % tileset.columns
            
            let texture = SpriteLoader.getSpriteTexture(tileset.source, column: column, row: row)
            
            spriteNode.texture = texture
            
        }
        
        return spriteNode
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
    
    func parserDidEndDocument(parser: NSXMLParser) {}
    
    func parserDidStartDocument(parser: NSXMLParser) {}
}
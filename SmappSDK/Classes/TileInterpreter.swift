//
//  TileInterpreter.swift
//  FBSnapshotTestCase
//
//  Created by farhad jebelli on 12/12/18.
//

import Foundation

enum GeometryCommand {
    case moveTo(point: CGPoint)
    case lineTo(point: CGPoint)
    case closePath
    case unknown
}

enum GeometyTypes {
    case point
    case lineString
    case polygon
    case unknown
    
    init(geomType: VectorTile_Tile.GeomType) {
        switch geomType {
        case .linestring:
            self = .lineString
        case .point:
            self = .point
        case .polygon:
            self = .polygon
        case .unknown:
            self = .unknown
        }
    }
}

class TileInterpreter {
    
    private var vectorTileLayer: VectorTile_Tile.Layer
    
    private var featureIndex: Int
    private var comandCountInFeature: Int! = nil
    
    private var commandIndex: Int! = nil {
        didSet {
            guard commandIndex != nil else {
                return
            }
            let geomInt = getGeomUInt32(index: commandIndex!)!
            thisCommandId = VectorTileUtils.commandId(commandInteger: geomInt)
            thisCommandCount = VectorTileUtils.commandCount(commandInteger: geomInt)
            if getGeomCount() <= commandIndex + thisCommandCount * 2 {
                thisCommandCount = (getGeomCount() - commandIndex - 1) / 2
            }
            commandParamIndex = 0
        }
    }
    private var commandParamIndex: Int! = nil
    
    private var thisCommandCount: Int! = nil
    private var thisCommandId: Int! = nil
    
    private var rect: CGRect
    
    init (vectorTileLayer: VectorTile_Tile.Layer, rect: CGRect) {
        self.vectorTileLayer = vectorTileLayer
        self.rect = rect
        featureIndex = -1
    }
    
    func nextCommand() -> GeometryCommand? {
        guard commandIndex != nil else {
            return nil
        }
        
        let paramIndex = commandIndex! + 1 + commandParamIndex! * 2
        defer {
            commandParamIndex += 1
            if commandParamIndex >= thisCommandCount {
                let commandNewIndex = commandIndex + thisCommandCount  * 2 + 1
                if commandNewIndex >= getGeomCount() {
                    commandIndex = nil
                }else {
                    commandIndex += thisCommandCount  * 2 + 1
                }
            }
        }
        
        switch thisCommandId {
        case 1:
            //moveTo
            guard let value = getParamersFromGeom(index: paramIndex) else {
                return nil
            }
            return .moveTo(point: value)
            
        case 2:
            //lineTo
            guard let value = getParamersFromGeom(index: paramIndex) else {
                return nil
            }
            return .lineTo(point: value)
        case 7:
            return .closePath
        default:
            return .unknown
        }
    }
    
    func nextFeature() -> GeometyTypes? {
        featureIndex += 1
        guard featureIndex < vectorTileLayer.features.count else {
            return nil
        }
        commandIndex = 0
        return GeometyTypes(geomType: vectorTileLayer.features[featureIndex].type)
    }
    
    private func getParamersFromGeom(index: Int) -> CGPoint? {
        guard let x = getValueFromGeom(index: index) ,
            let y = getValueFromGeom(index: index + 1) else {
                return nil
        }
        return CGPoint(x: x * rect.width,y: y * rect.height)
    }
    
    private func getValueFromGeom(index: Int) -> CGFloat? {
        guard let uint = getGeomUInt32(index: index) else {
            return nil
        }
        return CGFloat(VectorTileUtils.parameterValue(parameterInteger: uint)) / CGFloat(vectorTileLayer.extent)
    }
    
    private func getGeomUInt32(index: Int) -> UInt32? {
        if index >= getGeomCount() {
            return nil
        }
        return vectorTileLayer.features[featureIndex].geometry[index]
    }
    private func getGeomCount() -> Int {
        return vectorTileLayer.features[featureIndex].geometry.count
    }
    
}

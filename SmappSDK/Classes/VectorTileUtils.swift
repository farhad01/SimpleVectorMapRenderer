//
//  VectorTileUtils.swift
//  SmappSDK
//
//  Created by farhad jebelli on 12/12/18.
//

import Foundation

class VectorTileUtils {
    
    static func commandId(commandInteger: UInt32) -> Int {
        return Int(commandInteger & 0x7)
    }
    
    static func commandCount(commandInteger: UInt32) -> Int {
        return Int(commandInteger >> 3)
    }
    
    static func parameterValue(parameterInteger: UInt32) -> Int {
        let parameterInteger = Int32(parameterInteger)
        return Int((parameterInteger >> 1) ^ (-(parameterInteger & 1)))
    }
    
    static func tileLenght(zoom: Int) -> CGFloat {
        return Constants.mapWidth / pow(2, CGFloat(zoom)) * 200
    }
    
}


import Foundation
import UIKit
class TileProvider {
    
    var map: [URL: VectorTile_Tile] = [:]
    
    func image(zoom: UInt64, x: UInt64, y: UInt64) -> VectorTile_Tile? {
        
        guard let url = URL(string: "http://tileserver-staging.abar.cloud/data/v3/\(zoom)/\(x)/\(y).pbf") else {
            return nil
        }
        
        if let cashed = map[url] {
            return cashed
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        let tile = try? VectorTile_Tile(serializedData: data)
        map[url] = tile
        //let interpreter = TileInterpreter(vectorTileLayer: (tile?.layers.first)!)
        //print(tile?.layers.first)
//        var feature = interpreter.nextFeature()
//        while feature != nil {
//            print(feature)
//            var command = interpreter.nextCommand()
//            while command != nil {
//                print(command)
//                command = interpreter.nextCommand()
//            }
//            feature = interpreter.nextFeature()
//            
//            
//        }
//        print("end")
        
        return tile
        
    }
    
}

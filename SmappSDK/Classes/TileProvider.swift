
import Foundation
import UIKit
class TileProvider {
    
    func image(zoom: UInt64, x: UInt64, y: UInt64) -> VectorTile_Tile? {
        guard let url = URL(string: "http://tileserver-staging.abar.cloud/data/v3/\(zoom)/\(x)/\(y).pbf") else {
            return nil
        }
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        let tile = try? VectorTile_Tile(serializedData: data)
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


import Foundation
import UIKit
class TileProvider {
    
    func image(zoom: UInt64, x: UInt64, y: UInt64) -> VectorTile_Tile? {
        
        let string = "https://dev-tileserver.apps.public.teh-1.snappcloud.io/data/v3/\(zoom)/\(x)/\(y).pbf"
        guard let url = URL(string: string) else {
            return nil
        }
    
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        let tile = try? VectorTile_Tile(serializedData: data)

        
        return tile
        
    }
    
}

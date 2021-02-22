
import Foundation
import UIKit
class TileProvider {
    
    func image(zoom: Int64, x: Int64, y: Int64) -> VectorTile_Tile? {
        
        let string = "https://api.mapbox.com/v4/mapbox.mapbox-streets-v8/\(zoom)/\(x)/\(y).mvt?access_token=pk.eyJ1IjoiamViZWxsaS1mYXJoYWQiLCJhIjoiY2pwaWxmaWZoMDIxdDNwcHIzMXd5Y3dtMyJ9.QaTHPUcSJixLtncGsHxjLQ"
        guard let url = URL(string: string) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            let tile = try? VectorTile_Tile(serializedData: data)
            return tile
        } catch {
            print(error)
            return nil
        }
        
    }
    
}

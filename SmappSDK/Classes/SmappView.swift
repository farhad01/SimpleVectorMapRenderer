//
//  SmappView.swift
//  FBSnapshotTestCase
//
//  Created by farhad jebelli on 12/12/18.
//

class SmappView: UIView {
    
    var zoom: Int = 0
    
    
    var currnetLayer: Int = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    

    
    func setupViews() {
        tileLayer.levelsOfDetailBias = 2
    }
    
    func setZoomLevel(zoom: Int) {
        tileLayer.levelsOfDetail = zoom
        self.zoom = zoom
    }
    
    var tileLayer: CATiledLayer {
        return layer as! CATiledLayer
    }
    
    var sideLength: CGFloat = 0 {
        didSet {
            tileLayer.tileSize = CGSize(width: sideLength, height: sideLength)
        }
    }
    override public class var layerClass: AnyClass {
        return CATiledLayer.self
    }
    
    public override func draw(_ rect: CGRect) {
        let firstColumn = Int(rect.minX / sideLength)
        let lastColumn = Int(rect.maxX / sideLength)
        let firstRow = Int(rect.minY / sideLength)
        let lastRow = Int(rect.maxY / sideLength)
        
        
        for row in firstRow...lastRow {
            for column in firstColumn...lastColumn {
                guard let tile = TileProvider().image(zoom: UInt64(zoom), x:UInt64(column) , y: UInt64(row)) else {
                    return
                }
                let x = sideLength * CGFloat(column)
                let y = sideLength * CGFloat(row)
                let point = CGPoint(x: x, y: y)
                let size = CGSize(width: sideLength, height: sideLength)
                var tileRect = CGRect(origin: point, size: size)
                tileRect = bounds.intersection(tileRect)
                let contex = UIGraphicsGetCurrentContext()
                for layer in tile.layers {
                    drawLayer(contex: contex!, rect: tileRect, layer: layer)
                    
                }
            }
        }
        //ssuper.draw(rect)
    }
    
    
    private func drawLayer(contex: CGContext, rect: CGRect, layer: VectorTile_Tile.Layer) {
        let interpreter = TileInterpreter(vectorTileLayer: layer, rect: rect)
        var feature: GeometyTypes?
        repeat {
            feature = interpreter.nextFeature()
            guard feature != nil else {
                break
            }
            drawFeature(contex: contex, feature: feature!, rect: rect, interpreter: interpreter)
        } while (feature != nil)
        
    }
    
    
    
    private func drawFeature(contex: CGContext,feature: GeometyTypes,rect: CGRect,interpreter: TileInterpreter) {
        var command: GeometryCommand?
        var commandPoint: CGPoint = .zero
        let bezier = UIBezierPath()
        UIColor.white.setStroke()
        UIColor.red.setFill()
        
        bezier.lineWidth = 1
        repeat {
            command = interpreter.nextCommand()
            switch command ?? .unknown {
            case .moveTo(point: let point):
                commandPoint += point
                bezier.move(to: commandPoint + rect.origin)
            case .lineTo(point: let point):
                commandPoint += point
                bezier.addLine(to: commandPoint + rect.origin)
            case .closePath:
                bezier.close()
            case .unknown:
                ()
            }
            switch feature {
            case .point:
                break
            case .lineString:
                bezier.stroke()
            case .polygon:
                bezier.fill()
            case .unknown:
                break
            }
            
        } while (command != nil)
        
    }
    private func drawPoligon(contex: CGContext, interpreter: TileInterpreter) {
        
    }
    
    private func moveTo() {
        
    }
    
    private func lineTo() {
        
    }
    
    private func closePath() {
        
    }
    
    //    override public class func fadeDuration() -> CFTimeInterval {
    //        return 0.0
    //    }
    //    override var tileSize: CGSize {
    //        return
    //    }
}

//
//  SmappView.swift
//  FBSnapshotTestCase
//
//  Created by farhad jebelli on 12/12/18.
//
import UIKit
class SmappView: UIView {
    
    //var zoom: Int = 0
    var scrollview: SmappScrollView {
        superview as! SmappScrollView
    }
    
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
        tileLayer.levelsOfDetailBias = Int(Constants.zoomInLevels)
        tileLayer.levelsOfDetail = Int(Constants.zoomInLevels)
        tileLayer.contentsScale = 3
    }
    
    func setZoomLevel(zoom: Int) {
        
        //self.zoom = zoom
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
        let context = UIGraphicsGetCurrentContext()!
        
        let tileScale = context.ctm.a
        
        let scaleRect = rect.applying(CGAffineTransform(scaleX: tileScale, y: tileScale))
        
        let row = round(scaleRect.minX / tileLayer.tileSize.width)
        let col = round(scaleRect.minY / tileLayer.tileSize.width)
        
        let zoom = log2(tileScale)
        
//        let bez = UIBezierPath(rect: rect.insetBy(dx: 1, dy: 1))
//        UIColor.blue.setFill()
//        UIColor.red.setStroke()
//        bez.lineWidth = 4
//
//        bez.stroke()
//        bez.fill()
        

        
//        let attr = NSAttributedString(string: "\(row)  \(col)  \(zoom)")
//        attr.draw(in: rect.insetBy(dx: 3, dy: 3))

        
        
        guard let tile = TileProvider().image(zoom: Int64(zoom), x: Int64(row) , y: Int64(col)) else {
                    return
        }
        for layer in tile.layers {
            drawLayer(contex: context, rect: rect, layer: layer)
        }
//        let bezier = UIBezierPath(rect: rect)
//        var attr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 1 / tileScale)]
//        if (row + col).truncatingRemainder(dividingBy: 2) == 0 {
//            UIColor.black.setFill()
//            attr[NSAttributedString.Key.foregroundColor] = UIColor.white
//
//        } else {
//            UIColor.white.setFill()
//            attr[NSAttributedString.Key.foregroundColor] = UIColor.black
//        }
//        bezier.fill()
//
//        "[\(row), \(col)]".draw(at: rect.origin, withAttributes: attr)
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
        
        bezier.lineWidth = 1 / UIGraphicsGetCurrentContext()!.ctm.a
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
                break//bezier.fill()
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

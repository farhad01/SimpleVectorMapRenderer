//
//  SmappView.swift
//  FBSnapshotTestCase
//
//  Created by farhad jebelli on 12/12/18.
//

import UIKit

public class SmappView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override public class var layerClass: AnyClass {
        return SmappTiledLayer.self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
        backgroundColor = UIColor.gray
        tileLayer.tileSize = CGSize(width: 600, height: 600)
        
    }
    
    var tileLayer: CATiledLayer {
        return layer as! CATiledLayer
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func draw(_ rect: CGRect) {
        
        print(rect)
        let contex = UIGraphicsGetCurrentContext()
        guard let tile = TileProvider().image(zoom: 13, x: 5266, y: 3222) else {
            return
        }
        for layer in tile.layers {
            drawLayer(contex: contex!, rect: rect, layer: layer)

        }
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
 

}

class SmappTiledLayer: CATiledLayer {
    override class func fadeDuration() -> CFTimeInterval {
        return 0.0
    }
}

//
//  SmappView.swift
//  FBSnapshotTestCase
//
//  Created by farhad jebelli on 12/12/18.
//

import UIKit

public class SmappView: UIView {

    var tile: VectorTile_Tile!
    
    
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
        tile = TileProvider().image(zoom: 13, x: 5266, y: 3222)
        backgroundColor = UIColor.gray
        tileLayer.tileSize = CGSize(width: frame.width, height: frame.width)
        
    }
    
    var tileLayer: CATiledLayer {
        return layer as! CATiledLayer
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func draw(_ rect: CGRect) {
        
        let _ = TileProvider().image(zoom: 13, x: 5266, y: 3222)
        
        let contex = UIGraphicsGetCurrentContext()
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
        drawFeature(contex: contex, rect: rect, interpreter: interpreter)
    } while (feature != nil)
    
    

    //            bezierPath.lineWidth = 1
    //            bezierPath.stroke()
    
}


    
private func drawFeature(contex: CGContext,rect: CGRect,interpreter: TileInterpreter) {
    var command: GeometryCommand?
    var commandPoint: CGPoint = .zero
    let bezier = UIBezierPath()
    UIColor.white.setStroke()
    bezier.lineWidth = 1
    repeat {
        //contex.beginPath()
        //contex.setStrokeColor(UIColor.white.cgColor)
        //contex.setLineWidth(1)
        command = interpreter.nextCommand()
        switch command ?? .unknown {
        case .moveTo(point: let point):
            commandPoint += point
            //contex.move(to: commandPoint)
            bezier.move(to: commandPoint + rect.origin)
        case .lineTo(point: let point):
            commandPoint += point
            //contex.addLine(to: commandPoint)
            bezier.addLine(to: commandPoint + rect.origin)
        case .closePath:
            //contex.closePath()
            bezier.close()
        case .unknown:
            ()
        }
        
        //contex.strokePath()
        bezier.stroke()
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

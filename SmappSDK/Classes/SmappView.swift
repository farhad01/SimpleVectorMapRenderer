//
//  SmappView.swift
//  FBSnapshotTestCase
//
//  Created by farhad jebelli on 12/12/18.
//

class SmappView: UIView {
    
    var layers: [SmappTiledLayer] = []
    
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
        for zoom in (Constants.minZoom ... Constants.maxZoom) {
            let layer = SmappTiledLayer(frame: frame)
            layer.sideLength = VectorTileUtils.tileLenght(zoom: zoom)
            layer.zoom = zoom
            //layer.frame = frame
            layers.append(layer)
        }
        setZoomLevel(zoom: 0)
    }
    
    override func layoutSubviews() {
        subviews.first?.frame = frame
    }

    func setZoomLevel(zoom: Int) {
        layers[currnetLayer].removeFromSuperview()
        addSubview(layers[zoom])
        layers[zoom].frame = frame
        layers[zoom].bounds = bounds
        currnetLayer = zoom
    }
}

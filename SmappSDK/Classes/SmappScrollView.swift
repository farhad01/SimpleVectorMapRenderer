//
//  SmappScrollView.swift
//  SmappSDK
//
//  Created by farhad jebelli on 12/13/18.
//
import Foundation
import UIKit

public class SmappScrollView: UIScrollView {
    
    let smappView: SmappView
    
    var lastZoom: Int = 0
    
    public override init(frame: CGRect) {
        self.smappView = SmappView()
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.smappView = SmappView()
        super.init(coder: aDecoder)
        setupView()
    }
    
    public override var bounds: CGRect {
        didSet {
            print(123)
        }
    }
    
    private func setupView() {
        
        addSubview(smappView)
        //smappView.scrollView = self
        smappView.translatesAutoresizingMaskIntoConstraints = false
        smappView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        smappView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        smappView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        smappView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        smappView.widthAnchor.constraint(equalToConstant: Constants.sideLength).isActive = true
        smappView.heightAnchor.constraint(equalToConstant: Constants.sideLength).isActive = true

        smappView.sideLength = 1024
        
        delegate = self
        
        self.minimumZoomScale = pow(2, Constants.zoomOutLevels)
        self.maximumZoomScale = pow(2, Constants.zoomInLevels)

        zoomScale = 1
        bounds = CGRect(x: 0, y: 0, width: 1024, height: 1024)
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}

extension SmappScrollView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return smappView
    }
    
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let zoom = floor(scrollView.zoomScale)
        smappView.tileLayer.setNeedsDisplay()
        guard Int(zoom) != lastZoom, (1...14).contains(zoom) else {
            return
        }
        lastZoom = Int(zoom)
        smappView.setZoomLevel(zoom: lastZoom)
        
    }
}

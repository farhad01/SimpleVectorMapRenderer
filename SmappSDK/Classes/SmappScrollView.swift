//
//  SmappScrollView.swift
//  SmappSDK
//
//  Created by farhad jebelli on 12/13/18.
//
import Foundation
import UIKit

public class SmappScrollView: UIScrollView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
        let smappView = SmappView()
        addSubview(smappView)
        
        smappView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        smappView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        smappView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        smappView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        smappView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        smappView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
    }
    
}

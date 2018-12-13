//
//  CGUtils.swift
//  SmappSDK
//
//  Created by farhad jebelli on 12/13/18.
//

import Foundation

func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func +=( lhs: inout CGPoint, rhs: CGPoint) {
    lhs = rhs + lhs
}

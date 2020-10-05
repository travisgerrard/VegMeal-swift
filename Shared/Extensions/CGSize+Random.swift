//
//  CGSize+Random.swift
//  VegMeal
//
//  Created by Travis Gerrard on 10/3/20.
//


import SwiftUI

extension CGSize {
    static func random(width: ClosedRange<CGFloat>, height: ClosedRange<CGFloat>) -> CGSize {
        return CGSize(width: CGFloat.random(in: width), height: CGFloat.random(in: height))
    }
    
    static func random(in range: ClosedRange<CGFloat>) -> CGSize {
        return CGSize(width: CGFloat.random(in: range), height: CGFloat.random(in: range))
    }
}

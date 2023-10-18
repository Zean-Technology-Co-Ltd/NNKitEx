//
//  UIView+Gradient.swift
//  qpyf
//
//  Created by zq on 2023/3/3.
//

import UIKit

extension UIView{
    public enum AddGradientLayerType{
        case bottomToTop
        case topToBottom
        case rightToLeft
        case leftToRight
    }
    
    public func addGradientLayer(size: CGSize, type: AddGradientLayerType, startColor: String, endColor: String){
        let layer = gradientLayer(size: size, type: type, startColor: startColor, endColor: endColor)
        self.layer.insertSublayer(layer, at: 0)
    }
    
    public func gradientLayer(size: CGSize, startPoint: CGPoint, endPoint: CGPoint, startColor: String, endColor: String) -> CAGradientLayer{
        return gradientLayer(size: size, startPoint: startPoint, endPoint: endPoint, colors: [UIColor(hex: startColor).cgColor, UIColor(hex: endColor).cgColor])
    }
    
    public func gradientLayer(size: CGSize, type: AddGradientLayerType, startColor: String, endColor: String) -> CAGradientLayer{
        var startPoint: CGPoint = .zero
        var endPoint: CGPoint = .zero
        switch type {
        case .bottomToTop:
            startPoint = CGPoint(x: 0, y: 1)
            endPoint = CGPoint(x: 0, y: 0)
        case .topToBottom:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 0, y: 1)
        case .rightToLeft:
            startPoint = CGPoint(x: 1, y: 0)
            endPoint = CGPoint(x: 0, y: 0)
        case .leftToRight:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 1, y: 0)
        }
        
        let layer = gradientLayer(size: size,
                                     locations: [0, 1],
                                     startPoint: startPoint,
                                     endPoint: endPoint,
                                     colors: [UIColor(hex: startColor).cgColor, UIColor(hex: endColor).cgColor])
        return layer
    }
    
    public func gradientLayer(size: CGSize, locations: [NSNumber] = [0, 1],  startPoint: CGPoint, endPoint: CGPoint, colors: [Any]) -> CAGradientLayer{
        let layer = CAGradientLayer()
        layer.locations = locations
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        layer.colors = colors
        layer.startPoint = startPoint
        layer.endPoint = endPoint
        return layer
    }
    
}

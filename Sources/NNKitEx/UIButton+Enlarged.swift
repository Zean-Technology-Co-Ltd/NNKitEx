//
//  UIButton+Enlarged.swift
//  qpyf
//
//  Created by zq on 2023/3/3.
//

import UIKit

extension UIButton {
    private struct AssociatedKeys {
        static var topNameKey     = "topNameKey"
        static var rightNameKey   = "rightNameKey"
        static var bottomNameKey  = "bottomNameKey"
        static var leftNameKey    = "leftNameKey"
    }
    
    public func enlargeEdge(top: CGFloat, right: CGFloat, left: CGFloat, bottom: CGFloat){
        objc_setAssociatedObject(self, &AssociatedKeys.topNameKey, NSNumber(value: top), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &AssociatedKeys.rightNameKey, NSNumber(value: right), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &AssociatedKeys.bottomNameKey, NSNumber(value: bottom), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &AssociatedKeys.leftNameKey, NSNumber(value: left), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    private func enlargedRect() -> CGRect {
        let topEdge = objc_getAssociatedObject(self, &AssociatedKeys.topNameKey)
        let rightEdge = objc_getAssociatedObject(self, &AssociatedKeys.rightNameKey)
        let bottomEdge = objc_getAssociatedObject(self, &AssociatedKeys.bottomNameKey)
        let leftEdge = objc_getAssociatedObject(self, &AssociatedKeys.leftNameKey)
        if let topEdge = topEdge as? NSNumber,
           let rightEdge = rightEdge as? NSNumber,
           let bottomEdge = bottomEdge as? NSNumber,
           let leftEdge = leftEdge  as? NSNumber
        {
            return CGRectMake(self.bounds.origin.x - CGFloat(leftEdge.floatValue),
                              self.bounds.origin.y - CGFloat(topEdge.floatValue),
                              self.bounds.size.width + CGFloat(leftEdge.floatValue) + CGFloat(rightEdge.floatValue),
                              self.bounds.size.height + CGFloat(topEdge.floatValue) + CGFloat(bottomEdge.floatValue))
        }
        else
        {
            return self.bounds
        }
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let rect = enlargedRect();//获得了获得新范围的CGRect
        
        if CGRectEqualToRect(rect, self.bounds) || self.isHidden == true  //如果没有增加点击范围就调用super 看看点击范围是不是在父控件上
        {
            return super.hitTest(point, with: event)
        }
        //如果触摸点为在增加后的范围内就返回此view为触摸点
        return CGRectContainsPoint(rect, point) ? self : nil
    }
}

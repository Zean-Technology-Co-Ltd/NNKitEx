//
//  UILabel+Extension.swift
//  qpyf
//
//  Created by zq on 2023/3/3.
//

import UIKit

extension UILabel{
    public convenience init(font: UIFont, textColor: UIColor) {
        self.init()
        self.font = font
        self.textColor = textColor
    }
    
    public convenience init(text: String, font: UIFont, textColor: UIColor) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
    }
    
    public convenience init(text: String, font: UIFont, textColor: UIColor, numberOfLines: Int) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.numberOfLines = numberOfLines
    }
}

extension UILabel{
    private struct AssociatedKeys {
        static var whenTappedKey   = "whenTappedKey"
    }

    public func whenTapped(handler: @escaping () -> Void) {
        let aBlockClassWrapper = ClosureWrapper(closure: handler)
        objc_setAssociatedObject(self, &AssociatedKeys.whenTappedKey, aBlockClassWrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(UILabel.touchUpInside))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc public func touchUpInside() {
        let actionBlockAnyObject = objc_getAssociatedObject(self, &AssociatedKeys.whenTappedKey) as? ClosureWrapper
        actionBlockAnyObject?.closure?()
        self.tag = 0
    }
}

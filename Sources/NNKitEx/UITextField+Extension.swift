//
//  UITextField+Extension.swift
//  qpyf
//
//  Created by zq on 2023/3/3.
//

import UIKit
import FoundationEx

extension UITextField {
    public convenience init(attributedPlaceholder: String, color: UIColor, font: UIFont) {
        self.init()
        self.attributedPlaceholder = NSAttributedString(string: attributedPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.font : font])
    }
    
    public convenience init(color: UIColor, font: UIFont) {
        self.init()
        self.textColor = color
        self.font = font
    }
    
    public convenience init(text: String, color: UIColor, font: UIFont) {
        self.init()
        self.text = text
        self.textColor = color
        self.font = font
    }
    
    public convenience init(placeholder: String, color: UIColor, font: UIFont) {
        self.init()
        self.placeholder = placeholder
        self.textColor = color
        self.font = font
    }
    
    public convenience init(color: UIColor, font: UIFont, delegate: UITextFieldDelegate) {
        self.init()
        self.textColor = color
        self.font = font
        self.delegate = delegate
    }
    
    public convenience init(text: String, color: UIColor, font: UIFont, delegate: UITextFieldDelegate) {
        self.init()
        self.text = text
        self.textColor = color
        self.font = font
        self.delegate = delegate
    }
    
    public convenience init(placeholder: String, color: UIColor, font: UIFont, delegate: UITextFieldDelegate) {
        self.init()
        self.placeholder = placeholder
        self.textColor = color
        self.font = font
        self.delegate = delegate
    }
    
   public func setAttributedPlaceholder(_ attributedPlaceholder: String, color: UIColor, font: UIFont) {
        self.attributedPlaceholder = NSAttributedString(string: attributedPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.font : font])
    }
}

extension UITextField {

    private struct AssociatedKeys {
        static var whenTappedKey   = "whenTappedKey"
    }

    public func whenTapped(handler: @escaping () -> Void) {
        let aBlockClassWrapper = ClosureWrapper(closure: handler)
        objc_setAssociatedObject(self, &AssociatedKeys.whenTappedKey, aBlockClassWrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        self.addTarget(self, action: #selector(UITextField.touchUpInside), for: UIControl.Event.touchUpInside)
    }

    @objc public func touchUpInside() {
        let actionBlockAnyObject = objc_getAssociatedObject(self, &AssociatedKeys.whenTappedKey) as? ClosureWrapper
        actionBlockAnyObject?.closure?()
        self.tag = 0
    }
    
    
    /// 截取textfield字符长度
    ///
    /// - Parameter length
    public func interceptChar(to length: Int) {
        
        guard let text = self.text else { return }
        let lang = self.textInputMode?.primaryLanguage
        if lang == "zh-Hans" {
            if let _ =  self.markedTextRange  {
                return
            }
            if text.count > length {
                self.text = text.substring(to: length)
            }

        } else  if text.count > length {
            self.text = text.substring(to: length)
        }
        
    }
}

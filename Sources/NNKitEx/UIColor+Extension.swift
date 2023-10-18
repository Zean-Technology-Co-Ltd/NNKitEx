//
//  UIColor+Extension.swift
//  qpyf
//
//  Created by zq on 2023/3/3.
//

import UIKit

extension UIColor {

    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    public convenience init(hex: String) {
        self.init(hex: hex, alpha: 1)
    }
    
    public convenience init(_ val: UInt, alpha a: CGFloat = 1.0) {
        let r = ((CGFloat)((val & 0xFF0000) >> 16)) / 255.0
        let g = ((CGFloat)((val & 0xFF00) >> 8)) / 255.0
        let b = ((CGFloat)(val & 0xFF)) / 255.0
        self.init(r: r, g: g, b: b, a: a)
    }
    
    public convenience init(hex: String, alpha: CGFloat = 1.0) {
        //处理数值
        var cString = hex.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let length = (cString as NSString).length
        //错误处理
        if length < 6 || length > 7 || (!cString.hasPrefix("#") && length == 7) || (cString.hasPrefix("#") && length != 7) {
            //返回whiteColor
            self.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            return
        }
        if cString.hasPrefix("#") {
            cString = (cString as NSString).substring(from: 1)
        }
        //字符chuan截取
        var range = NSRange()
        range.location = 0
        range.length = 2
        
        let rString = (cString as NSString).substring(with: range)
        
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        //存储转换后的数值
        var r:UInt32 = 0, g:UInt32 = 0, b:UInt32 = 0
        //进行转换
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        //根据颜色值创建UIColor
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
}

extension UIColor {
    public convenience init(gray: CGFloat) {
        self.init(r: gray, g: gray, b: gray, a: 1)
    }
}

extension UIColor{
    public func toImage() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    public func alpha(_ alpha: CGFloat) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
}

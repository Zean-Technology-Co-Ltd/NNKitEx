//
//  UIButton+Extension.swift
//  qpyf
//
//  Created by zq on 2023/3/3.
//

import UIKit
import FoundationEx

extension UIButton{
    public convenience init(imgName name: String, enlargeEdge enlarge: CGFloat = 0) {
        self.init()
        self.setImage(UIImage(named: name), for: .normal)
        self.enlargeEdge(top: enlarge, right: enlarge, left: enlarge, bottom: enlarge)
    }
    
    public convenience init(imgName name: String, enlargeEdge enlarge: CGFloat = 0, target: Any, action: Selector) {
        self.init()
        self.setImage(UIImage(named: name), for: .normal)
        self.enlargeEdge(top: enlarge, right: enlarge, left: enlarge, bottom: enlarge)
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
    public convenience init(title: String, font: UIFont) {
        self.init()
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = font
    }
    
    public convenience init(textColor: UIColor, font: UIFont) {
        self.init()
        self.setTitleColor(textColor, for: .normal)
        self.titleLabel?.font = font
    }
    
    public convenience init(title: String, textColor: UIColor, font: UIFont) {
        self.init()
        self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.titleLabel?.font = font
    }
    
    public convenience init(attributedTitle: String, attributedColor: UIColor, textColor: UIColor, font: UIFont, range: NSRange) {
        self.init()
        let attributedString = attributedTitle.attribute(attributedColor, font: font, range: range)
        self.setAttributedTitle(attributedString, for: .normal)
        self.titleLabel?.font = font
        self.setTitle(attributedTitle, for: .normal)
        self.setTitleColor(textColor, for: .normal)
    }
    
    public convenience init(title: String, textColor: UIColor, font: UIFont, for state: UIControl.State) {
        self.init()
        self.setTitle(title, for: state)
        self.setTitleColor(textColor, for: state)
        self.titleLabel?.font = font
    }
    
    public convenience init(title: String, textColor: UIColor, font: UIFont, target: Any, action: Selector) {
        self.init()
        self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.titleLabel?.font = font
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
    public func setBackgroundColor(_ color: UIColor, for state: UIControl.State){
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        self.setBackgroundImage(image, for: state)
    }
    
    public func setTitle(title: String, textColor: UIColor, for state: UIControl.State) {
        self.setTitle(title, for: state)
        self.setTitleColor(textColor, for: state)
    }
}

extension UIButton{
    public func setUrlImage(_ url: String?, for state: UIControl.State) {
        guard let url = url else { return }
        self.sd_setImage(with: URL(string: url), for: state)
    }
    
    public func setUrlBackgroundImage(_ url: String?, for state: UIControl.State) {
        guard let url = url else { return }
        self.sd_setBackgroundImage(with: URL(string: url), for: state)
    }
    
    public func setImage(imgName name: String, for state: UIControl.State) {
        self.setImage(UIImage(named: name), for: state)
    }
    
    public func setBackgroundImage(imgName name: String, for state: UIControl.State) {
        self.setBackgroundImage(UIImage(named: name), for: state)
    }
    
    public func localImage(name: String, type: String){
        let path = Bundle.main.path(forResource: name, ofType: type)
        guard let path = path else { return }
        self.sd_setImage(with: URL(fileURLWithPath: path), for: .normal, completed:{ [weak self] image, error, cacheType, imageURL in
            guard let image = image else { return }
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.setImage(image, for: .normal)
            }
        })
    }
}

extension UIButton{
    public func verticalImageAndTitle(spacing: CGFloat) {
        let imageSize = self.imageView!.frame.size
        var titleSize = self.titleLabel!.frame.size
        let text: NSString = self.titleLabel!.text! as NSString
        let textSize = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11)])
        let frameSize = CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
        if (titleSize.width + 0.5 < frameSize.width) {
            titleSize.width = frameSize.width;
        }
        let totalHeight = (imageSize.height + titleSize.height + spacing)
        
        
        let imageHeight = self.imageView!.frame.height
        let labelHeight = self.titleLabel!.frame.height
        let buttonHeight = self.frame.height
        let boundsCentery = (imageHeight + spacing + labelHeight) * 0.5
        
        let centerX_button = self.bounds.midX // bounds
        let centerX_image = self.imageView!.frame.midX
        
        let imageTopY = self.imageView!.frame.minY
        
        let imageInsetsTop = (buttonHeight * 0.5 - boundsCentery) - imageTopY
        let imageInsetsLeft = centerX_button - centerX_image
        let imageInsetsRight = -imageInsetsLeft
        let imageInsetsBottom = -imageInsetsTop
        self.imageEdgeInsets = UIEdgeInsets(top: imageInsetsTop, left: imageInsetsLeft, bottom: imageInsetsBottom, right: imageInsetsRight);

        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(totalHeight - titleSize.height), right: 0);
    }
}

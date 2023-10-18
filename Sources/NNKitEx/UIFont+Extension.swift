//
//  UIFont+Extension.swift
//  qpyf
//
//  Created by zq on 2023/3/3.
//

import UIKit

extension UIFont{
    public class func semibold(_ font: CGFloat)-> UIFont {
        return self.systemFont(ofSize: font, weight: .semibold)
    }
    
    public class func bold(_ font: CGFloat)-> UIFont {
        return self.systemFont(ofSize: font, weight: .bold)
    }
    
    public class func light(_ font: CGFloat)-> UIFont {
        return self.systemFont(ofSize: font, weight: .light)
    }
    
    public class func medium(_ font: CGFloat)-> UIFont {
        return self.systemFont(ofSize: font, weight: .medium)
    }
    
    public class func regular(_ font: CGFloat)-> UIFont {
        return self.systemFont(ofSize: font, weight: .regular)
    }
    
    public class func heavy(_ font: CGFloat)-> UIFont {
        return self.systemFont(ofSize: font, weight: .heavy)
    }
}

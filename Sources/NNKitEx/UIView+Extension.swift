//
//  UIView+Extension.swift
//  qpyf
//
//  Created by zq on 2023/3/3.
//

import UIKit

private var innerTapActionKey: UInt8 = 0
private var innerTapActionParametricKey: UInt8 = 0

public protocol ReusableView: AnyObject { }

public extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return "\(self)"
    }
}

public protocol NibLoadableView: AnyObject { }

extension NibLoadableView where Self: UIView {
    internal static var nibName: String {
        return String(self)
    }
}

extension UIView: ReusableView { }

extension UIView: NibLoadableView { }

extension UIView{
    
    public class func getNib() -> UINib {
        return UINib(nibName: "\(self)", bundle: nil)
    }

    public class func initFromNib() -> Self {
        return Bundle.loadNib(self)
    }
}

extension Bundle {
    class func loadNib<T>(_ Type: T.Type) -> T {
        let identifier = "\(String(describing: T.self))".components(separatedBy: ".").first!
        return (self.main.loadNibNamed(identifier, owner: self, options: nil)?[0] as? T)!
    }
}

class ClosureWrapper: NSObject, NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        let wrapper: ClosureWrapper = ClosureWrapper()
        wrapper.closure = closure
        return wrapper
    }

    var closure: (() -> Void)?
    public convenience init(closure: (() -> Void)?) {
        self.init()
        self.closure = closure
    }
}

extension UIView {
    
    public func findSubviews<T: UIView>(_ viewClass: T.Type) -> [T] {
        return subviews.compactMap { $0 as? T }
    }
    
    public func findSubviews<T: UIView>(_ predicate: (T)->(Bool)) -> [T] {
        return subviews.compactMap {
            guard let t = $0 as? T else {
                return nil
            }
            return predicate(t) ? t : nil
        }
    }
    
}

extension UIView {
    /** 裁剪 view 的圆角
     * ⚠️ 使用相对布局可能会裁剪失败
     */
    public func clipRectCorner(_ roundedRect: CGRect = .zero, direction: UIRectCorner, cornerRadius: CGFloat) {
         let cornerSize = CGSize(width: cornerRadius, height: cornerRadius)
        let bounds = roundedRect == .zero ? bounds : roundedRect
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: direction, cornerRadii: cornerSize)
         let maskLayer = CAShapeLayer()
         maskLayer.path = maskPath.cgPath
         layer.mask = maskLayer
     }

    public func clipLayerCorner(radius: CGFloat, clipsToBounds clip: Bool = true) {
        clipLayerCorner(radius: radius, borderWidth: 0, borderColor: nil, clipsToBounds: clip)
    }
    
    public func clipLayerCorner(radius: CGFloat, borderWidth width: CGFloat, borderColor color: UIColor?, clipsToBounds clip: Bool = true) {
        self.layer.cornerRadius = radius
        self.layer.borderColor = color?.cgColor
        self.layer.borderWidth = width
        self.clipsToBounds = clip
    }
    
    public func addShadow(offset: CGSize = .zero) {
        addShadow(offset: offset, color: UIColor.black, opacity: 0.1)
    }
    
    public func addShadow(offset: CGSize = .zero, color: UIColor = UIColor.black, opacity: Float) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        clipsToBounds = false
    }
    
    public func addCornerShadow(radius: CGFloat = 5) {
        addCornerShadow(offset: .zero, color: .black, opacity: 0.2, radius: radius)
    }
    
    public func addCornerShadow(bounds:CGRect = .zero,  offset: CGSize = .zero, color: UIColor = UIColor.black, opacity: Float, radius: CGFloat = 5) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.cornerRadius = radius
        let shadowPath = UIBezierPath(roundedRect: bounds == CGRect.zero ? self.bounds : bounds, cornerRadius: radius)
        self.layer.shadowPath = shadowPath.cgPath
    }
}

extension UIView {

    public func addTapAction(action: (() -> Void)?) {
        innerTapAction = action
        let tap = UITapGestureRecognizer(target: self, action: #selector(executeTapAction))
        addGestureRecognizer(tap)
    }
    
    public func addTapActionParametric(action: ((UIView) -> Void)?) {
        innerTapActionParametric = action
        let tap = UITapGestureRecognizer(target: self, action: #selector(executeTapActionParametric(_:)))
        addGestureRecognizer(tap)
    }

    @objc public func executeTapAction() {
        innerTapAction?()
    }
    
    @objc public func executeTapActionParametric(_ gesture: UIGestureRecognizer) {
        if let view = gesture.view {
            innerTapActionParametric?(view)
        }
    }
}

extension UIView {

    public var innerTapAction:(() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &innerTapActionKey) as? () -> Void
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self, &innerTapActionKey, newValue as () -> Void, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
        }
    }
    
    public var innerTapActionParametric:((UIView) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &innerTapActionParametricKey) as? (UIView) -> Void
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self, &innerTapActionParametricKey, newValue as (UIView) -> Void, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
        }
    }
}

// MARK: - Extended Rotation
extension UIView {

    public var isRotating: Bool {
        return layer.animation(forKey: "extendedRotation") != nil
    }

    public func startRotate() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2.0)
        rotateAnimation.duration = 1.0
        rotateAnimation.repeatCount = MAXFLOAT
        layer.add(rotateAnimation, forKey: "extendedRotation")
    }

    public func stopRotate() {
        layer.removeAnimation(forKey: "extendedRotation")
    }

    public func rotate180() {
        UIView.animate(withDuration: 0.2, animations: {
            let angle = self.tag == 1 ? 0 : CGFloat.pi
            self.transform = CGAffineTransform(rotationAngle: angle)
            self.tag = self.tag == 1 ? 0 : 1
        })
    }

    public func addBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }

}

// MARK: Frame Extensions
extension UIView {

    /// EZSwiftExtensions, add multiple subviews
    public func addSubviews(_ views: [UIView]) {
        views.forEach { eachView in
            self.addSubview(eachView)
        }
    }
    
    public func removeAllSubviews() {
        while (self.subviews.count != 0) {
            self.subviews.last?.removeFromSuperview()
        }
    }


    /// EZSwiftExtensions, resizes this view so it fits the largest subview
    public func resizeToFitSubviews() {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for someView in self.subviews {
            let aView = someView
            let newWidth = aView.x + aView.w
            let newHeight = aView.y + aView.h
            width = max(width, newWidth)
            height = max(height, newHeight)
        }
        frame = CGRect(x: x, y: y, width: width, height: height)
    }

    /// EZSwiftExtensions, resizes this view so it fits the largest subview
    public func resizeToFitSubviews(_ tagsToIgnore: [Int]) {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for someView in self.subviews {
            let aView = someView
            if !tagsToIgnore.contains(someView.tag) {
                let newWidth = aView.x + aView.w
                let newHeight = aView.y + aView.h
                width = max(width, newWidth)
                height = max(height, newHeight)
            }
        }
        frame = CGRect(x: x, y: y, width: width, height: height)
    }

    /// EZSwiftExtensions
    public func resizeToFitWidth() {
        let currentHeight = self.h
        self.sizeToFit()
        self.h = currentHeight
    }

    /// EZSwiftExtensions
    public func resizeToFitHeight() {
        let currentWidth = self.w
        self.sizeToFit()
        self.w = currentWidth
    }

    /// EZSwiftExtensions
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        } set(value) {
            self.frame = CGRect(x: value, y: self.y, width: self.w, height: self.h)
        }
    }

    /// EZSwiftExtensions
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        } set(value) {
            self.frame = CGRect(x: self.x, y: value, width: self.w, height: self.h)
        }
    }

    /// EZSwiftExtensions
    public var w: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: value, height: self.h)
        }
    }

    /// EZSwiftExtensions
    public var h: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: self.w, height: value)
        }
    }

    /// EZSwiftExtensions
    public var left: CGFloat {
        get {
            return self.x
        } set(value) {
            self.x = value
        }
    }
    
    public var maxX: CGFloat {
        get {
            return self.x+self.w
        }
    }
    public var maxY: CGFloat {
        get {
            return self.y+self.h
        }
    }

    /// EZSwiftExtensions
    public var right: CGFloat {
        get {
            return self.x + self.w
        } set(value) {
            self.x = value - self.w
        }
    }

    /// EZSwiftExtensions
    public var top: CGFloat {
        get {
            return self.y
        } set(value) {
            self.y = value
        }
    }

    /// EZSwiftExtensions
    public var bottom: CGFloat {
        get {
            return self.y + self.h
        } set(value) {
            self.y = value - self.h
        }
    }

    /// EZSwiftExtensions
    public var origin: CGPoint {
        get {
            return self.frame.origin
        } set(value) {
            self.frame = CGRect(origin: value, size: self.frame.size)
        }
    }

    /// EZSwiftExtensions
    public var centerX: CGFloat {
        get {
            return self.center.x
        } set(value) {
            self.center.x = value
        }
    }

    /// EZSwiftExtensions
    public var centerY: CGFloat {
        get {
            return self.center.y
        } set(value) {
            self.center.y = value
        }
    }

    /// EZSwiftExtensions
    public var size: CGSize {
        get {
            return self.frame.size
        } set(value) {
            self.frame = CGRect(origin: self.frame.origin, size: value)
        }
    }

    /// EZSwiftExtensions
    public func leftOffset(_ offset: CGFloat) -> CGFloat {
        return self.left - offset
    }

    /// EZSwiftExtensions
    public func rightOffset(_ offset: CGFloat) -> CGFloat {
        return self.right + offset
    }

    /// EZSwiftExtensions
    public func topOffset(_ offset: CGFloat) -> CGFloat {
        return self.top - offset
    }

    /// EZSwiftExtensions
    public func bottomOffset(_ offset: CGFloat) -> CGFloat {
        return self.bottom + offset
    }

    
    /// EZSwiftExtensions
    public func alignRight(_ offset: CGFloat) -> CGFloat {
        return self.w - offset
    }

    /// EZSwiftExtensions
    public func reorderSubViews(_ reorder: Bool = false, tagsToIgnore: [Int] = []) -> CGFloat {
        var currentHeight: CGFloat = 0
        for someView in subviews {
            if !tagsToIgnore.contains(someView.tag) && !(someView ).isHidden {
                if reorder {
                    let aView = someView
                    aView.frame = CGRect(x: aView.frame.origin.x, y: currentHeight, width: aView.frame.width, height: aView.frame.height)
                }
                currentHeight += someView.frame.height
            }
        }
        return currentHeight
    }

    public func removeSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }

    /// EZSE: Centers view in superview horizontally
    public func centerXInSuperView() {
        guard let parentView = superview else {
            assertionFailure("EZSwiftExtensions Error: The view \(self) doesn't have a superview")
            return
        }

        self.x = parentView.w / 2 - self.w / 2
    }

    /// EZSE: Centers view in superview vertically
    public func centerYInSuperView() {
        guard let parentView = superview else {
            assertionFailure("EZSwiftExtensions Error: The view \(self) doesn't have a superview")
            return
        }

        self.y = parentView.h / 2 - self.h / 2
    }

    /// EZSE: Centers view in superview horizontally & vertically
    public func centerInSuperView() {
        self.centerXInSuperView()
        self.centerYInSuperView()
    }
}


extension UIView {

    public func addDashedLine(color: UIColor = UIColor(r: 98, g: 98, b: 98), size: CGSize, lineWidth: CGFloat, name: String = "DashedLine") {
        self.removeDashedLine(name: name)

        let layer = CAShapeLayer()
        layer.name = name
        layer.strokeColor = color.cgColor
        layer.fillColor = nil
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        layer.path = UIBezierPath(rect:rect).cgPath
        layer.frame = rect
        layer.lineWidth = lineWidth
        layer.lineDashPattern = [4, 4]
        self.layer.addSublayer(layer)
    }
    
    public func removeDashedLine(name: String? = nil) {
        if name == nil {
            if let layers = self.layer.sublayers {
                for (index, value) in layers.enumerated() {
                    if value is CAShapeLayer {
                        self.layer.sublayers?[index].removeFromSuperlayer()
                        break
                    }
                }
            }
        } else {
            self.layer.sublayers?.filter({ $0.name == name }).forEach({ $0.removeFromSuperlayer() })
        }
    }
}

extension UIView {
    
    public class func defaultSpringAnimate (animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        self.animate(withDuration: 0.3,
                     delay: 0,
                     usingSpringWithDamping: 1,
                     initialSpringVelocity: 0,
                     options: .curveEaseInOut,
                     animations: animations,
                     completion:completion)
    }
    
    public class func dampingSpringAnimate (animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        self.animate(withDuration: 0.3,
                     delay: 0,
                     usingSpringWithDamping: 0.5,
                     initialSpringVelocity: 1,
                     options: .curveEaseInOut,
                     animations: animations,
                     completion: completion)
    }
    
    public class func movingSpringAnimate (animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        self.animate(withDuration: 0.3,
                     delay: 0,
                     usingSpringWithDamping: 0.9,
                     initialSpringVelocity: 0.5,
                     options: .curveEaseInOut,
                     animations: animations,
                     completion: completion)
    }
    
    public class func cellExpandSpringAnimate (animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        self.animate(withDuration: 0.5,
                     delay: 0,
                     usingSpringWithDamping: 0.5,
                     initialSpringVelocity: 0.5,
                     options: .curveEaseInOut,
                     animations: animations,
                     completion: completion)
    }
    
    public class func defaultBackAnimate (animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        self.animate(withDuration: 0.3, animations: animations, completion: completion)
    }
    
}

extension UIView{
    public var navigationController: UINavigationController?{
        var nextResponder = self.next
        while nextResponder != nil {
            if nextResponder is UINavigationController{
                return (nextResponder as! UINavigationController)
            }
            nextResponder = nextResponder?.next
        }
        return nil;
    }
    
    public var viewController: UIViewController? {
        get {
            var nextResponder = self.next
            while nextResponder != nil {
                if nextResponder is UIViewController{
                    return (nextResponder as! UIViewController)
                }
                nextResponder = nextResponder?.next
            }
            return nil;
        }
    }
}

extension UIView {
    
    @IBInspectable
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = newValue
        }
    }
}

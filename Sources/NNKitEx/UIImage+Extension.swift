//
//  UIImage+Extension.swift
//  qpyf
//
//  Created by zq on 2023/3/3.
//

import UIKit

extension UIImage {

    public func resizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    public func cropImageToSquare() -> UIImage? {
        var imageHeight = self.size.height
        var imageWidth = self.size.width
        
        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        let refWidth : CGFloat = CGFloat(self.cgImage!.width)
        let refHeight : CGFloat = CGFloat(self.cgImage!.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let imageRef = self.cgImage!.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: self.imageOrientation)
        }
        
        return nil
    }
    
    
    public func imageWithTintColor(_ color: UIColor) -> UIImage? {

        assert(!size.equalTo(.zero))

        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }

    public class func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0 / UIScreen.main.scale)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1.0, height: 1.0 / UIScreen.main.scale),
                                               false,
                                               UIScreen.main.scale)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    public func roundedCornerImageWithCornerRadius(_ cornerRadius: CGFloat) -> UIImage {

        let w = self.size.width
        let h = self.size.height

        var targetCornerRadius = cornerRadius
        if cornerRadius < 0 {
            targetCornerRadius = 0
        }
        if cornerRadius > min(w, h) {
            targetCornerRadius = min(w, h)
        }

        let imageFrame = CGRect(x: 0, y: 0, width: w, height: h)
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)

        UIBezierPath(roundedRect: imageFrame, cornerRadius: targetCornerRadius).addClip()
        self.draw(in: imageFrame)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }

}


extension UIImage{
    /// 仅仅识别二维码图片
    public func parseQRCode() -> String? {
        guard let ciimg = CIImage(image: self) else {
            return nil
        }
        let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                  context: nil,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        guard let features = detector?.features(in: ciimg) else {
            return nil
        }
        guard let feature = features.first(where: { $0.type == CIFeatureTypeQRCode }) as? CIQRCodeFeature else {
            return nil
        }
        return feature.messageString // 识别结果
    }
    
    
}

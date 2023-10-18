//
//  UIViewController+Extension.swift
//  qpyf
//
//  Created by zq on 2023/3/3.
//

import UIKit

private var UIViewControllerLoadingKey: UInt8 = 0

extension UIViewController {
    public func dismissKeyboard(targetView: UIView) {
        let singleTapGR = UITapGestureRecognizer(target: self, action: #selector(tapAnywhereToDismissKeyboard));
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                               object: nil,
                                               queue: OperationQueue.main) { noti in
            targetView.addGestureRecognizer(singleTapGR)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                               object: nil,
                                               queue: OperationQueue.main) { noti in
            targetView.removeGestureRecognizer(singleTapGR)
        }
    }
    
    @objc public  func tapAnywhereToDismissKeyboard() {
        self.view.endEditing(true)
    }
    
    public func popToViewController(vcType: UIViewController.Type){
        if let controllers = self.navigationController?.viewControllers {
            for vc in controllers {
                if vc.isKind(of: vcType) {
                    self.navigationController?.popToViewController(vc, animated: true)
                    break
                }
            }
        }
    }
}

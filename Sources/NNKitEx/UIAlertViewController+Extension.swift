//
//  UIAlertViewController+Extension.swift
//  NiuNiuRent
//
//  Created by 张泉 on 2023/4/19.
//

import UIKit

extension UIAlertController {
    
   public func addActions(_ actions: [UIAlertAction]) {
        actions.forEach { (action) in
            self.addAction(action)
        }
    }
    
    public func addActionsWithCancel(actions: [UIAlertAction]) {
        self.addActions(actions)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        self.addAction(cancelAction)
    }
    
    public static func showWith(title: String?, message: String?, isShowCancel: Bool = false, actionTitle: String, target: UIViewController, callback: @escaping (()->())) {
        let sureAction = UIAlertAction(title: actionTitle, style: .default) { alert in
            callback()
        }
        showWith(title: title, message: message, withCancelAction: isShowCancel, actions: [sureAction], target: target)
    }
    
    
    public static func showWith(title: String?, message: String?, withCancelAction: Bool, actions: [UIAlertAction], target: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        if withCancelAction {alert.addAction(cancelAction)}
        alert.addActions(actions)
        target.present(alert, animated: true, completion: nil)
    }
}

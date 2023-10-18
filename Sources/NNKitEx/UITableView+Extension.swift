//
//  UITableView+Extension.swift
//  qpyf
//
//  Created by zq on 2023/3/3.
//

import UIKit

extension UITableView {
    public func register<T: UITableViewCell>(nib: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }

    public func register<T: UITableViewCell>(_ type: T.Type) {
        self.registers([type])
    }

    public func registers(_ cellTypes: [UITableViewCell.Type]) {
        for `class` in cellTypes {
            self.register(`class`, forCellReuseIdentifier: `class`.reuseIdentifier)
        }
    }
}

extension UITableView {

    public func dequeue<T: UITableViewCell>(_ cellType: T.Type,
                                     identifier: String = T.reuseIdentifier) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? T else {
            fatalError("Could not dequeue cell with identifier: \(identifier)")
        }
        
        return cell
    }
}

extension UITableViewCell {
    public func cellWithTableView<T: UITableViewCell>(_ tableView: UITableView) -> T {
        var cell = tableView.dequeueReusableCell(withIdentifier: T.reuseIdentifier)
        if cell == nil {
            cell = T(style: .default, reuseIdentifier: T.reuseIdentifier)
            cell?.selectionStyle = .none
        }
        return cell as! T
    }
}

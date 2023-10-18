//
//  UICollectionView+Extension.swift
//  qpyf
//
//  Created by zq on 2023/3/3.
//

import UIKit

public enum SectionHeadFooterkind: String {
    case header = "UICollectionElementKindSectionHeader"
    case footer = "UICollectionElementKindSectionFooter"
}

extension UICollectionView {
    public func deselectAll() {
        for indexPath in self.indexPathsForSelectedItems! {
            self.deselectItem(at: indexPath, animated: true)
        }
    }
}

extension UICollectionView {
    
    public func registerNibs(_ cellTypes: [UICollectionViewCell.Type]) {
        for `class` in cellTypes {
            let nib = UINib(nibName: `class`.nibName, bundle: nil)
            register(nib, forCellWithReuseIdentifier: `class`.reuseIdentifier)
        }
    }
    
    public func register<T: UICollectionViewCell>(nib: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    public func register<T: UICollectionViewCell>(_ type: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    public func registers(_ cellTypes: [UICollectionViewCell.Type]) {
        for `class` in cellTypes {
            self.register(`class`, forCellWithReuseIdentifier: `class`.reuseIdentifier)
        }
    }

    public func register<T: UICollectionReusableView>(_ viewType: T.Type, kind: SectionHeadFooterkind) {
        self.registers([viewType], kind: kind)
    }

    public func registers<T: UICollectionReusableView>(_ viewTypes: [T.Type], kind: SectionHeadFooterkind) {
        for cellClass in viewTypes {
            self.register(cellClass, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: cellClass.reuseIdentifier)
        }
    }
}

extension UICollectionView {
    public func dequeue<T: UICollectionViewCell>(_ cellClass: T.Type,
                                          reuseIdentifier: String = T.reuseIdentifier,
                                          forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(reuseIdentifier)")
        }
        return cell
    }
    
    public func dequeueReusableView<T: UICollectionReusableView>(_ supplementaryViewClass: T.Type,
                                              kind: SectionHeadFooterkind,
                                          reuseIdentifier: String = T.reuseIdentifier,
                                          forIndexPath indexPath: IndexPath) -> T {
        
        guard let header = dequeueReusableSupplementaryView(ofKind: kind.rawValue, 
                                                            withReuseIdentifier: reuseIdentifier, 
                                                            for: indexPath)  as? T else {
            fatalError("Could not dequeue header with identifier: \(reuseIdentifier)")
        }
        
        return header
    }
}

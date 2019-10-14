//
//  Cell+Reuse.swift
//  CravingForSound
//
//  Created by Rodion on 08/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension UITableViewCell {
    
    class var defaultIdentifier: String {
        return "\(self)"
    }
    
}

extension UICollectionViewCell {
    
    class var defaultIdentifier: String {
        return "\(self)"
    }
    
}

extension UITableView {

    //Cell.defaultIdentifier couldn't be used as default value for reuseIdentifier
    //because it will fail when dealing with protocols
    func register<Cell: UITableViewCell>(_ type: Cell.Type, for reuseIdentifier: String = Cell.defaultIdentifier) {
        register(type, forCellReuseIdentifier: reuseIdentifier)
    }

    //Cell.defaultIdentifier couldn't be used as default value for reuseIdentifier
    //because it will fail when dealing with protocols
    func dequeueCellOrFatalError<Cell: UITableViewCell>(_ type: Cell.Type,
                                                        identifier: String? = nil,
                                                        for indexPath: IndexPath) -> Cell {
        let cell = dequeueReusableCell(withIdentifier: identifier ?? type.defaultIdentifier, for: indexPath)
        if let cell = cell as? Cell {
            return cell
        } else {
            fatalError("Cell type mismatch; Got \(Swift.type(of: cell)) instead of \(type)")
        }
    }
    
}

extension UICollectionView {

    //Cell.defaultIdentifier couldn't be used as default value for reuseIdentifier
    //because it will fail when dealing with protocols
    func register<Cell: UICollectionViewCell>(_ type: Cell.Type, for reuseIdentifier: String? = nil) {
        register(type, forCellWithReuseIdentifier: reuseIdentifier ?? type.defaultIdentifier)
    }

    //Cell.defaultIdentifier couldn't be used as default value for reuseIdentifier
    //because it will fail when dealing with protocols
    func dequeueCellOrFatalError<Cell: UICollectionViewCell>(_ type: Cell.Type,
                                                             identifier: String? = nil,
                                                             for indexPath: IndexPath) -> Cell {
        let cell = dequeueReusableCell(withReuseIdentifier: identifier ?? type.defaultIdentifier, for: indexPath)
        if let cell = cell as? Cell {
            return cell
        } else {
            fatalError("Cell type mismatch; Got \(Swift.type(of: cell)) instead of \(type)")
        }
    }
    
}

extension Reactive where Base: UICollectionView {

    public func items<S: Sequence, Cell: UICollectionViewCell, O: ObservableType>
        (cellType: Cell.Type = Cell.self)
        -> (_ source: O)
        -> (_ configureCell: @escaping (Int, S.Iterator.Element, Cell) -> Void)
        -> Disposable where O.Element == S {
            return items(cellIdentifier: cellType.defaultIdentifier, cellType: cellType)
    }

}

extension Reactive where Base: UITableView {

    public func items<S: Sequence, Cell: UITableViewCell, O: ObservableType>
        (cellType: Cell.Type = Cell.self)
        -> (_ source: O)
        -> (_ configureCell: @escaping (Int, S.Iterator.Element, Cell) -> Void)
        -> Disposable
        where O.Element == S {
            return items(cellIdentifier: cellType.defaultIdentifier, cellType: cellType)
    }

}

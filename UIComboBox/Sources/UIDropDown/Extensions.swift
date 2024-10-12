//
//  Helpers.swift
//  UIComboBox
//
//  Created by Robert Andrzejczyk on 23/03/2024.
//

import UIKit

extension CGRect {
    
    public var foldedUp: CGRect {
        inset(by: UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0))
    }
    
    public var foldedDown: CGRect {
        inset(by: UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0))
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Could not dequeue a tableview cell with the identifier: \(T.self)")
        }
        return cell
    }
    
    func register<T: UITableViewCell>(cell: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }
}

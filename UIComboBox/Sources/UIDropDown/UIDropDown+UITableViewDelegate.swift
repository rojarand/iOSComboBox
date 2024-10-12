//
//  UIDropDown+UITableViewDelegate.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import Foundation

// MARK: - UITableViewDelegate
internal let DefaultDropDownCellHeight = 40.0

extension UIDropDown: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if delegate?.responds(to: #selector(UIDropDownDelegate.dropDown(_:heightForRowAt:))) == true {
            return (delegate?.dropDown?(self, heightForRowAt: indexPath.row))!
        } else {
            return DefaultDropDownCellHeight
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.dropDown(self, didSelectRowAt: indexPath)//TODO
        anchorView?.resignFirstResponder()
        hide()
    }
}

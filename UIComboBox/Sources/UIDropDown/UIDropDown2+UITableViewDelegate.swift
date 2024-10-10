//
//  UIDropDown2+UITableViewDelegate.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import Foundation

// MARK: - UITableViewDelegate
internal let DefaultDropDownCellHeight = 40.0

extension UIDropDown2: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        NSLog("---Calculating tableView height")
        
        if delegate2?.responds(to: #selector(UIDropDown2Delegate.dropDown(_:heightForRowAt:))) == true {
            return (delegate2?.dropDown?(self, heightForRowAt: indexPath.row))!
        } else {
            return DefaultDropDownCellHeight
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate2?.dropDown(self, didSelectRowAt: indexPath)//TODO
        anchorView?.resignFirstResponder()
        hide()
    }
}

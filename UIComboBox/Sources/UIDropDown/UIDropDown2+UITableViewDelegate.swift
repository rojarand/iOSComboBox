//
//  UIDropDown2+UITableViewDelegate.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import Foundation

// MARK: - UITableViewDelegate

extension UIDropDown2: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        NSLog("---Calculating tableView height")
        return 40.0
//        44.0
        //delegate?.dropDown(self, heightForRowAt: indexPath) ?? 0.0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate2?.dropDown(self, didSelectRowAt: indexPath)
        anchorView?.resignFirstResponder()
        hide()
    }
}

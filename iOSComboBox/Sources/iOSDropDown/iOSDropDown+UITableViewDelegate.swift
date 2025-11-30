//
//  iOSDropDown+UITableViewDelegate.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import UIKit

// MARK: - UITableViewDelegate

let defaultDropDownCellHeight = 40.0

extension iOSDropDown: UITableViewDelegate {
    public func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if delegate?.responds(to: #selector(iOSDropDownDelegate.dropDown(_:heightForRowAt:))) == true {
            return (delegate?.dropDown?(self, heightForRowAt: indexPath.row))!
        } else {
            return defaultDropDownCellHeight
        }
    }

    public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.dropDown(self, didSelectRowAt: indexPath)
        anchorView?.resignFirstResponder()
        hide()
    }
}

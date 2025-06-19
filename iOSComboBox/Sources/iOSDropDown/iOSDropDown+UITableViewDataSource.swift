//
//  iOSDropDown+UITableViewDataSource.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import UIKit

extension iOSDropDown: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if delegate?.responds(to: #selector(iOSDropDownDelegate.dropDown(_:cellProvider:forRowAt:))) == true {
            let cellProvider = UITableViewCellProvider(tableView: tableView)
            return (delegate?.dropDown?(self, cellProvider: cellProvider, forRowAt: indexPath.row))!
        } else {
            let objectValue: Any = delegate?.dropDown(self, objectValueForItemAt: indexPath.row) ?? "\(indexPath.row)"
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "\(objectValue)"
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate?.numberOfRows(in: self) ?? 0
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if delegate?.responds(to: #selector(iOSDropDownDelegate.dropDown(_:commit:forRowAt:))) == true {
            if delegate?.responds(to: #selector(iOSDropDownDelegate.dropDown(_:canEditRowAt:))) == true {
                return (delegate?.dropDown?(self, canEditRowAt: indexPath.row))!
            } else {
                return true
            }
        }
        return false
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if delegate?.responds(to: #selector(iOSDropDownDelegate.dropDown(_:commit:forRowAt:))) == true {
            delegate?.dropDown?(self, commit: editingStyle, forRowAt: indexPath.row)
            tableView.reloadData()
        }
    }
}

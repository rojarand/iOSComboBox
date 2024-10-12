//
//  UIDropDown+UITableViewDataSource.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import Foundation

extension UIDropDown: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if delegate?.responds(to: #selector(UIDropDownDelegate.dropDown(_:cellProvider:cellForRowAt:))) == true {
            let cellProvider = UITableViewCellProvider(tableView: tableView)
            return (delegate?.dropDown?(self, cellProvider: cellProvider, cellForRowAt: indexPath.row))!
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
}

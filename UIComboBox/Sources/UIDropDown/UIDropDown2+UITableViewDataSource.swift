//
//  UIDropDown2+UITableViewDataSource.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import Foundation

extension UIDropDown2: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objectValue: Any = delegate2?.dropDown(self, objectValueForItemAt: indexPath.row) ?? "\(indexPath.row)"
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "\(objectValue)"
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate2?.numberOfRows(in: self) ?? 0
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    /*
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        delegate?.dropDown(self, canEditRowAt: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        delegate?.dropDown(self, commit: editingStyle, forRowAt: indexPath)
    }*/
}

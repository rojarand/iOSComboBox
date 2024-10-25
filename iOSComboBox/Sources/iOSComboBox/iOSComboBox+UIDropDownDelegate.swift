//
//  iOSComboBox+UIDropDownDelegate.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import Foundation

extension iOSComboBox: iOSDropDownDelegate {
    public func numberOfRows(in dropDown: iOSDropDown) -> Int {
        comboBoxDataSource?.numberOfItems?(in: self) ?? 0
    }
    
    public func dropDown(_ dropDown: iOSDropDown, objectValueForItemAt index: Int) -> Any? {
        comboBoxDataSource?.comboBox?(self, objectValueForItemAt: index)
    }
    
    public func dropDown(_ dropDown: iOSDropDown, didSelectRowAt indexPath: IndexPath) {
        if let objectValue = comboBoxDataSource?.comboBox?(self, objectValueForItemAt: indexPath.row) {
            text = "\(objectValue)"
        }
        if comboBoxDelegate?.responds(to: #selector(ComboBoxDelegate.comboBox(_:didSelectRowAt:))) == true {
            comboBoxDelegate?.comboBox?(self, didSelectRowAt: indexPath.row)
        }
    }
    
    public func dropDown(_ dropDown: iOSDropDown, cellProvider: UITableViewCellProvider, cellForRowAt position: Int) -> UITableViewCell {
        if comboBoxDataSource?.responds(to: #selector(iOSComboBoxDataSource.comboBox(_:cellProvider:cellForRowAt:))) == true {
            return (comboBoxDataSource?.comboBox?(self, cellProvider: cellProvider, cellForRowAt: position))!
        } else {
            let objectValue: Any = comboBoxDataSource?.comboBox?(self, objectValueForItemAt: position) ?? "\(position)"
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "\(objectValue)"
            return cell
        }
    }
    
    public func dropDown(_ dropDown: iOSDropDown, heightForRowAt position: Int) -> CGFloat {
        if comboBoxDelegate?.responds(to: #selector(ComboBoxDelegate.comboBox(_:heightForRowAt:))) == true {
            return (comboBoxDelegate?.comboBox?(self, heightForRowAt: position))!
        } else {
            return DefaultDropDownCellHeight
        }
    }
    
    /*
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if delegate2?.responds(to: #selector(UIDropDownDelegate.dropDown(_:cellProvider:cellForRowAt:))) == true {
            let cellProvider = UITableViewCellProvider(tableView: tableView)
            return (delegate2?.dropDown?(self, cellProvider: cellProvider, cellForRowAt: indexPath.row))!
        } else {
            let objectValue: Any = delegate2?.dropDown(self, objectValueForItemAt: indexPath.row) ?? "\(indexPath.row)"
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "\(objectValue)"
            return cell
        }
    }*/
}

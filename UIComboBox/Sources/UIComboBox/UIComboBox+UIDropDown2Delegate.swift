//
//  UIComboBox+UIDropDown2Delegate.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import Foundation

extension UIComboBox: UIDropDown2Delegate {
    public func numberOfRows(in dropDown: UIDropDown2) -> Int {
        comboBoxDataSource?.numberOfItems?(in: self) ?? 0
    }
    
    public func dropDown(_ dropDown2: UIDropDown2, objectValueForItemAt index: Int) -> Any? {
        comboBoxDataSource?.comboBox?(self, objectValueForItemAt: index)
    }
    
    public func dropDown(_ dropDown2: UIDropDown2, didSelectRowAt indexPath: IndexPath) {
        if let objectValue = comboBoxDataSource?.comboBox?(self, objectValueForItemAt: indexPath.row) {
            text = "\(objectValue)"
        }
        if comboBoxDelegate?.responds(to: #selector(ComboBoxDelegate.comboBox(_:didSelectRowAt:))) == true {
            comboBoxDelegate?.comboBox?(self, didSelectRowAt: indexPath.row)
        }
    }
    
    public func dropDown(_ dropDown2: UIDropDown2, cellProvider: UITableViewCellProvider, cellForRowAt position: Int) -> UITableViewCell {
        if comboBoxDataSource?.responds(to: #selector(UIComboBoxDataSource.comboBox(_:cellProvider:cellForRowAt:))) == true {
            return (comboBoxDataSource?.comboBox?(self, cellProvider: cellProvider, cellForRowAt: position))!
        } else {
            let objectValue: Any = comboBoxDataSource?.comboBox?(self, objectValueForItemAt: position) ?? "\(position)"
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "\(objectValue)"
            return cell
        }
    }
    
    public func dropDown(_ dropDown2: UIDropDown2, heightForRowAt position: Int) -> CGFloat {
        if comboBoxDelegate?.responds(to: #selector(ComboBoxDelegate.comboBox(_:heightForRowAt:))) == true {
            return (comboBoxDelegate?.comboBox?(self, heightForRowAt: position))!
        } else {
            return DefaultDropDownCellHeight
        }
    }
    
    /*
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if delegate2?.responds(to: #selector(UIDropDown2Delegate.dropDown(_:cellProvider:cellForRowAt:))) == true {
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

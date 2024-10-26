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
        if comboBoxDelegate?.responds(to: #selector(iOSComboBoxDelegate.comboBox(_:didSelectRowAt:))) == true {
            comboBoxDelegate?.comboBox?(self, didSelectRowAt: indexPath.row)
        }
    }
    
    public func dropDown(_ dropDown: iOSDropDown, cellProvider: UITableViewCellProvider, forRowAt index: Int) -> UITableViewCell {
        if comboBoxDataSource?.responds(to: #selector(iOSComboBoxDataSource.comboBox(_:cellProvider:forRowAt:))) == true {
            return (comboBoxDataSource?.comboBox?(self, cellProvider: cellProvider, forRowAt: index))!
        } else {
            let objectValue: Any = comboBoxDataSource?.comboBox?(self, objectValueForItemAt: index) ?? "\(index)"
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "\(objectValue)"
            return cell
        }
    }
    
    public func dropDown(_ dropDown: iOSDropDown, commit editingStyle: UITableViewCell.EditingStyle, forRowAt index: Int) {
        if comboBoxDataSource?.responds(to: #selector(iOSComboBoxDataSource.comboBox(_:commit:forRowAt:))) == true {
            comboBoxDataSource?.comboBox?(self, commit: editingStyle, forRowAt: index)
        }
    }
    
    public func dropDown(_ dropDown: iOSDropDown, canEditRowAt index: Int) -> Bool {
        if comboBoxDataSource?.responds(to: #selector(iOSComboBoxDataSource.comboBox(_:commit:forRowAt:))) == true {
            if comboBoxDataSource?.responds(to: #selector(iOSComboBoxDataSource.comboBox(_:canEditRowAt:))) == true {
                return (comboBoxDataSource?.comboBox?(self, canEditRowAt: index))!
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    public func dropDown(_ dropDown: iOSDropDown, heightForRowAt index: Int) -> CGFloat {
        if comboBoxDelegate?.responds(to: #selector(iOSComboBoxDelegate.comboBox(_:heightForRowAt:))) == true {
            return (comboBoxDelegate?.comboBox?(self, heightForRowAt: index))!
        } else {
            return DefaultDropDownCellHeight
        }
    }
}

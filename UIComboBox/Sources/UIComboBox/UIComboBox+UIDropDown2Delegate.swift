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
        comboBoxDelegate?.comboBox?(self, didSelectRowAt: indexPath.row)
    }
}

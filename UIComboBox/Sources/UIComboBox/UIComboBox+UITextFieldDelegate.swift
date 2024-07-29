//
//  UIComboBox+UITextFieldDelegate.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import Foundation

extension UIComboBox: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        dropDown.delegate2 = self
        dropDown.show()
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        dropDown.delegate2 = self
        dropDown.show()
        return true
    }
}
//
//  iOSComboBox+UITextFieldDelegate.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import Foundation

extension iOSComboBox: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        dropDown.delegate = self
        dropDown.show()
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        dropDown.delegate = self
        dropDown.show()
        return true
    }
}

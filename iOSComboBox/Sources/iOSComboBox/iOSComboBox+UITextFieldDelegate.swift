//
//  iOSComboBox+UITextFieldDelegate.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import UIKit

// MARK: - Proxy Delegate

class ComboBoxDelegateProxy: NSObject, UITextFieldDelegate {
    
    weak var originalDelegate: UITextFieldDelegate?
    weak var comboBox: iOSComboBox?
    
    init(comboBox: iOSComboBox) {
        self.comboBox = comboBox
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        comboBox?.dropDown.show()
        return originalDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        comboBox?.dropDown.hide()
        originalDelegate?.textFieldDidEndEditing?(textField)
    }
    
    // Forward any other UITextFieldDelegate methods to the original delegate
    override func responds(to aSelector: Selector!) -> Bool {
        (originalDelegate?.responds(to: aSelector) ?? false) || super.responds(to: aSelector)
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        originalDelegate
    }
}


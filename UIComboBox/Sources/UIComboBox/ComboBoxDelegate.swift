//
//  ComboBoxDelegate.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import Foundation

@objc public protocol ComboBoxDelegate/* : NSTextFieldDelegate*/ {
//    @objc @MainActor optional func comboBoxWillPopUp(_ notification: Notification)
//    @objc @MainActor optional func comboBoxWillDismiss(_ notification: Notification)
//    @objc @MainActor optional func comboBoxSelectionDidChange(_ notification: Notification)
//    @objc @MainActor optional func comboBoxSelectionIsChanging(_ notification: Notification)
    
    @objc @MainActor optional func comboBoxSelectionDidChange(_ comboBox: UIComboBox)
    @objc @MainActor optional func comboBox(_ comboBox: UIComboBox, didSelectRowAt index: Int)
}

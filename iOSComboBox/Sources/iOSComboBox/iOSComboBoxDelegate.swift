//
//  iOSComboBoxDelegate.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import Foundation

@objc public protocol iOSComboBoxDelegate: NSObjectProtocol/* : NSTextFieldDelegate*/ {
//    @objc @MainActor optional func comboBoxWillPopUp(_ notification: Notification)
//    @objc @MainActor optional func comboBoxWillDismiss(_ notification: Notification)
//    @objc @MainActor optional func comboBoxSelectionDidChange(_ notification: Notification)
//    @objc @MainActor optional func comboBoxSelectionIsChanging(_ notification: Notification)
//    @objc @MainActor optional func comboBoxSelectionDidChange(_ comboBox: iOSComboBox)
    @objc @MainActor optional func comboBox(_ comboBox: iOSComboBox, didSelectRowAt index: Int)
    @objc @MainActor optional func comboBox(_ comboBox: iOSComboBox, heightForRowAt index: Int) -> CGFloat
}

extension iOSComboBoxDelegate {
    @MainActor func comboBox(_ comboBox: iOSComboBox, didSelectRowAt index: Int) {
        print("Default implementation of optionalMethod.")
    }
}

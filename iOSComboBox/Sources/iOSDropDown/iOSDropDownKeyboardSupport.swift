//
//  iOSDropDownKeyboardSupport.swift
//  iOSComboBox
//
//  Created by Robert Andrzejczyk on 17/08/2025.
//

import Foundation

class iOSDropDownKeyboardSupport {
    
    private(set) var isKeyboardVisible: Bool?
    private(set) var keyboardFrame: CGRect?
    private let dropDownPresenter: iOSDropDownPresenter
    
    init(dropDownPresenter: iOSDropDownPresenter) {
        self.dropDownPresenter = dropDownPresenter
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        isKeyboardVisible = true
        keyboardFrame = keyboardFrame(fromNotification: notification) ?? .zero
        let keyboardAnimationDuration = (keyboardAnimationDuration(fromNotification: notification) ?? Self.defaultKeyboardAnimationDuration) + 0.05
        dropDownPresenter.showDropDownWhenKeyboardIsDisplayed(keyboardAnimationDuration: keyboardAnimationDuration)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        keyboardFrame = keyboardFrame(fromNotification: notification) ?? .zero
    }
    
    @objc private func keyboardDidHide(_ notification: Notification) {
        if isKeyboardVisible == true {
            dropDownPresenter.repositionDropDownOnKeyboardDidHide()
        }
        keyboardFrame = keyboardFrame(fromNotification: notification) ?? .zero
        isKeyboardVisible = false
    }
    
    private static var defaultKeyboardAnimationDuration: TimeInterval {
        0.25
    }
    
    private func keyboardFrame(fromNotification notification: Notification) -> CGRect? {
        (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
    
    private func keyboardAnimationDuration(fromNotification notification: Notification) -> TimeInterval? {
        (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
    }
}

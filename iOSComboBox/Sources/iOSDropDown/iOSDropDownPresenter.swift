//
//  iOSDropDownPresenter.swift
//  iOSComboBox
//
//  Created by Robert Andrzejczyk on 29/07/2025.
//

import Foundation

class iOSDropDownPresenter {
    private weak var dropDown: iOSDropDown?
    private var propertyObservations = [NSKeyValueObservation]()
    private var showLaterWorkItem: DispatchWorkItem?
    
    func setUp(dropDown: iOSDropDown) {
        self.dropDown = dropDown
        if propertyObservations.isEmpty {
            hideOnScroll(of: dropDown.anchorView)
        }
    }
    
    func tearDown() {
        propertyObservations.removeAll()
        cancel()
    }
    
    func cancel() {
        showLaterWorkItem?.cancel()
        showLaterWorkItem = nil
    }
    
    func showDropDownWhenKeyboardIsDisplayed(keyboardAnimationDuration delay: TimeInterval) {
        cancel()
        cancelAnimation()
        showLater(delay: delay)
    }
    
    func repositionDropDownOnKeyboardDidHide() {
        hideIfNeededAndShowLater(delay: 0.0)
    }
    
    private func hideOnScroll(of view: UIView?) {
        guard let currentView = view else { return }
        if let scrollView = currentView as? UIScrollView {
            let observation = scrollView.observe(\.contentOffset, options: [.old, .new]) { [weak self] object, change in
                if change.newValue != change.oldValue {
                    self?.hideIfNeededAndShowLater(delay: 0.3)
                }
            }
            self.propertyObservations.append(observation)
        }
        hideOnScroll(of: currentView.superview)
    }
    
    private func hideIfNeededAndShowLater(delay: TimeInterval) {
        guard let dropDown = self.dropDown else { return }
        if !dropDown.isHidden {
            dropDown.hide()
        } else {
            cancelAnimation()
        }
        cancel()
        showLater(delay: delay)
    }
    
    private func showLater(delay: TimeInterval) {
        let dispatchWorkItem = DispatchWorkItem { [weak self] in
            self?.dropDown?.showDropDown(animate: true, delay: 0.0, requiresFirstResponder: true)
            self?.showLaterWorkItem = nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: dispatchWorkItem)
        self.showLaterWorkItem = dispatchWorkItem
    }
    
    private func cancelAnimation() {
        dropDown?.dropDownAnimator.cancel()
    }
}

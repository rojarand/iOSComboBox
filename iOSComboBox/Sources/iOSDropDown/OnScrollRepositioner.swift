//
//  OnScrollRepositioner.swift
//  iOSComboBox
//
//  Created by Robert Andrzejczyk on 19/06/2025.
//

import Foundation

internal class OnScrollRepositioner {
    private var propertyObservations = [NSKeyValueObservation]()
    private weak var dropDown: iOSDropDown?
    private var showLaterWorkItem: DispatchWorkItem?
    
    func setUp(dropDown: iOSDropDown) {
        if propertyObservations.isEmpty {
            self.dropDown = dropDown
            hideOnScroll(of: dropDown.anchorView)
        }
    }
    
    func tearDown() {
        propertyObservations.removeAll()
    }
    
    private func hideOnScroll(of view: UIView?) {
        guard let currentView = view else { return }
        if let scrollView = currentView as? UIScrollView {
            let observation = scrollView.observe(\.contentOffset, options: [.old, .new]) { [weak self] object, change in
                if change.newValue != change.oldValue {
                    self?.hideIfNeededAndShowLater()
                }
            }
            self.propertyObservations.append(observation)
        }
        hideOnScroll(of: currentView.superview)
    }
    
    private func hideIfNeededAndShowLater() {
        guard let dropDown = self.dropDown else { return }
        if !dropDown.isHidden {
            dropDown.hide()
        } else {
            guard let showLaterWorkItem = self.showLaterWorkItem else { return }
            showLaterWorkItem.cancel()
        }
        let dispatchWorkItem = DispatchWorkItem { [weak self] in
            self?.dropDown?.show()
            self?.showLaterWorkItem = nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: dispatchWorkItem)
        self.showLaterWorkItem = dispatchWorkItem
    }
}

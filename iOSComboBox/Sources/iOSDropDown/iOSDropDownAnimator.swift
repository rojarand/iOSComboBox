//
//  iOSDropDownAnimator.swift
//  iOSComboBox
//
//  Created by Robert Andrzejczyk on 30/07/2025.
//

import Foundation


class iOSDropDownAnimator {
    
    private var propertyAnimator: UIViewPropertyAnimator?
    
    func cancel() {
        propertyAnimator?.stopAnimation(true)
        propertyAnimator = nil
    }
    
    func animate(afterDelay delay: TimeInterval, animation: @escaping ()->Void) {
        propertyAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: animation)
        propertyAnimator?.startAnimation(afterDelay: delay)
    }
}

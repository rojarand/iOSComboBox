//
//  UITextField+DropDown.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import UIKit

private var associatedDropDownKey: UInt = 0xC0B0C0B0

extension UITextField {
    
    internal var dropDown: iOSDropDown {
        get {
            if let dropDown = objc_getAssociatedObject(self, &associatedDropDownKey) as? iOSDropDown {
                return dropDown
            } else {
                let dropDown = iOSDropDown(anchorView: self)
                objc_setAssociatedObject(self, &associatedDropDownKey, dropDown, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return dropDown
            }
        }
    }
    
}

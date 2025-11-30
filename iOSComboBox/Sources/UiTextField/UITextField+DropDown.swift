//
//  UITextField+DropDown.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import UIKit

private var associatedDropDownKey: UInt = 0xC0B0_C0B0

extension UITextField {
    var dropDown: iOSDropDown {
        if let dropDown = objc_getAssociatedObject(self, &associatedDropDownKey) as? iOSDropDown {
            return dropDown
        } else {
            let dropDown = iOSDropDown(anchorView: self)
            objc_setAssociatedObject(self, &associatedDropDownKey, dropDown, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return dropDown
        }
    }
}

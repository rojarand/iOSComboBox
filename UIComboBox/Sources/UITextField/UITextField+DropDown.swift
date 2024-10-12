//
//  UITextField+DropDown.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import UIKit

private var associatedDropDownKey: UInt8 = 0

extension UITextField {
    
    internal var dropDown: UIDropDown {
        get {
            if let dropDown = objc_getAssociatedObject(self, &associatedDropDownKey) as? UIDropDown {
                return dropDown
            } else {
                let dropDown = UIDropDown(anchorView: self)
                objc_setAssociatedObject(self, &associatedDropDownKey, dropDown, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return dropDown
            }
        }
    }
}

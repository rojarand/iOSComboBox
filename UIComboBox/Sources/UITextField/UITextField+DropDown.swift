//
//  UITextField+DropDown.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import UIKit

private var associatedDropDownKey: UInt8 = 0

extension UITextField {
    
    internal var dropDown: UIDropDown2 {
        get {
            if let dropDown = objc_getAssociatedObject(self, &associatedDropDownKey) as? UIDropDown2 {
                return dropDown
            } else {
                let dropDown = UIDropDown2(anchorView: self)
                objc_setAssociatedObject(self, &associatedDropDownKey, dropDown, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return dropDown
            }
        }
    }
}

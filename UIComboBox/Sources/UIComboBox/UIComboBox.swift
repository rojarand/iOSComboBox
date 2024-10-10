//
//  UIComboBox.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import Foundation

open class UIComboBox: UITextField {
    
    public weak var comboBoxDataSource: UIComboBoxDataSource?
    public weak var comboBoxDelegate: ComboBoxDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        self.delegate = self
        self.isAccessibilityElement = false
        
    }
    
    public func register<T: UITableViewCell>(cell: T.Type) {
        dropDown.register(cell: cell)
    }
    
    /*
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let result = super.hitTest(point, with:event) {
            return result
        }
        for subview in self.subviews.reversed() {
            let point = self.convert(point, to:subview)
            if let result = subview.hitTest(point, with:event) {
                return result
            }
        }
        return nil
    }*/
}

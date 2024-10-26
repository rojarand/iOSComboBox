//
//  iOSComboBox.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import Foundation

open class iOSComboBox: UITextField {
    
    @objc public weak var comboBoxDataSource: iOSComboBoxDataSource?
    @objc public weak var comboBoxDelegate: iOSComboBoxDelegate?
    
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
    
    //convenience method for swift
    public func register<T: UITableViewCell>(cellClass: T.Type) {
        dropDown.register(cellClass: cellClass)
    }
    
    @objc public func registerCellClass(_ cellClass: AnyClass, forCellReuseIdentifier identifier: String) {
        dropDown.registerCellClass(cellClass, forCellReuseIdentifier: identifier)
    }
}

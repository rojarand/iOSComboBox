//
//  iOSComboBox.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import UIKit

open class iOSComboBox: UITextField {
    
    @objc public weak var comboBoxDataSource: iOSComboBoxDataSource?
    @objc public weak var comboBoxDelegate: iOSComboBoxDelegate?
    
    // MARK: - Properties
    private var proxyDelegate: ComboBoxDelegateProxy!
    weak var textFieldDelegate: UITextFieldDelegate? {
        didSet {
            proxyDelegate.originalDelegate = textFieldDelegate
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        proxyDelegate = ComboBoxDelegateProxy(comboBox: self)
        super.delegate = proxyDelegate
        dropDown.delegate = self
        accessibilityTraits = [.searchField]
    }
    
    //convenience method for swift
    public func register<T: UITableViewCell>(cellClass: T.Type) {
        dropDown.register(cellClass: cellClass)
    }
    
    @objc public func registerCellClass(_ cellClass: AnyClass, forCellReuseIdentifier identifier: String) {
        dropDown.registerCellClass(cellClass, forCellReuseIdentifier: identifier)
    }
    
    public override var delegate: UITextFieldDelegate? {
        didSet {
            textFieldDelegate = delegate
            super.delegate = proxyDelegate
        }
    }
    
    @objc public func reloadData() {
        dropDown.reloadData()
    }
}

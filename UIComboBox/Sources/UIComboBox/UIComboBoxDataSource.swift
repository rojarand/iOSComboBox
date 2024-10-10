//
//  UIComboBoxDataSource.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import Foundation

@objc public protocol UIComboBoxDataSource : NSObjectProtocol {
    
    /* These two methods are required when not using bindings */
    @objc @MainActor optional func numberOfItems(in comboBox: UIComboBox) -> Int
    @objc @MainActor optional func comboBox(_ comboBox: UIComboBox, objectValueForItemAt index: Int) -> Any?
    @objc @MainActor optional func comboBox(_ comboBox: UIComboBox, indexOfItemWithStringValue string: String) -> Int
    @objc @MainActor optional func comboBox(_ comboBox: UIComboBox, completedString string: String) -> String?
    
    @objc @MainActor optional func comboBox(_ comboBox: UIComboBox, cellProvider: UITableViewCellProvider, cellForRowAt position: Int) -> UITableViewCell
}

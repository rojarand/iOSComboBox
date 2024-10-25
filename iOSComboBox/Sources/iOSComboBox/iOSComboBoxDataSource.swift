//
//  iOSComboBoxDataSource.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import Foundation

@objc public protocol iOSComboBoxDataSource : NSObjectProtocol {
    
    /* These two methods are required when not using bindings */
    @objc @MainActor optional func numberOfItems(in comboBox: iOSComboBox) -> Int
    @objc @MainActor optional func comboBox(_ comboBox: iOSComboBox, objectValueForItemAt index: Int) -> Any?
    @objc @MainActor optional func comboBox(_ comboBox: iOSComboBox, indexOfItemWithStringValue string: String) -> Int
    @objc @MainActor optional func comboBox(_ comboBox: iOSComboBox, completedString string: String) -> String?
    
    @objc @MainActor optional func comboBox(_ comboBox: iOSComboBox, cellProvider: UITableViewCellProvider, cellForRowAt position: Int) -> UITableViewCell
}

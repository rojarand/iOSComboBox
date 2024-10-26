//
//  iOSComboBoxDataSource.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import Foundation

@objc public protocol iOSComboBoxDataSource : NSObjectProtocol {
    
    @objc @MainActor optional func numberOfItems(in comboBox: iOSComboBox) -> Int
    @objc @MainActor optional func comboBox(_ comboBox: iOSComboBox, objectValueForItemAt index: Int) -> Any?
    @objc @MainActor optional func comboBox(_ comboBox: iOSComboBox, indexOfItemWithStringValue string: String) -> Int
    @objc @MainActor optional func comboBox(_ comboBox: iOSComboBox, completedString string: String) -> String?
    
    @objc @MainActor optional func comboBox(_ comboBox: iOSComboBox, cellProvider: UITableViewCellProvider, forRowAt index: Int) -> UITableViewCell
    @objc @MainActor optional func comboBox(_ comboBox: iOSComboBox, commit editingStyle: UITableViewCell.EditingStyle, forRowAt index: Int)
    @objc @MainActor optional func comboBox(_ comboBox: iOSComboBox, canEditRowAt index: Int) -> Bool
}

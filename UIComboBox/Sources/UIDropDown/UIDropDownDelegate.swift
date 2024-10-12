//
//  UIDropDownDelegate.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import Foundation

public class UITableViewCellProvider: NSObject {
    private let tableView: UITableView
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    public func dequeCell<T: UITableViewCell>(atRow row: Int) -> T {
        tableView.dequeueReusableCell(withIdentifier: String(describing: T.self), for: IndexPath(row: row, section: 0)) as! T
    }
}

@objc public protocol UIDropDownDelegate: NSObjectProtocol {
    @objc @MainActor func numberOfRows(in dropDown: UIDropDown) -> Int
    @objc @MainActor func dropDown(_ dropDown: UIDropDown, objectValueForItemAt index: Int) -> Any?
    @objc @MainActor func dropDown(_ dropDown: UIDropDown, didSelectRowAt: IndexPath)
    @objc @MainActor optional func dropDown(_ dropDown: UIDropDown, cellProvider: UITableViewCellProvider, cellForRowAt position: Int) -> UITableViewCell
    @objc @MainActor optional func dropDown(_ dropDown: UIDropDown, heightForRowAt position: Int) -> CGFloat
}

extension UITableView {
    func calculateTableViewHeight() -> CGFloat {
        var totalHeight: CGFloat = 0.0
        
        // Loop through all sections
        for section in 0..<self.numberOfSections {
            // Add the height of the section header, if any
            if let headerHeight = self.delegate?.tableView?(self, heightForHeaderInSection: section) {
                totalHeight += headerHeight
            } else {
                totalHeight += self.sectionHeaderHeight
            }
            
            // Loop through all rows in the section
            for row in 0..<self.numberOfRows(inSection: section) {
                if let rowHeight = self.delegate?.tableView?(self, heightForRowAt: IndexPath(row: row, section: section)) {
                    totalHeight += rowHeight
                } else {
                    totalHeight += self.rowHeight
                }
            }
            
            // Add the height of the section footer, if any
            if let footerHeight = self.delegate?.tableView?(self, heightForFooterInSection: section) {
                totalHeight += footerHeight
            } else {
                totalHeight += self.sectionFooterHeight
            }
        }
        
        return totalHeight
    }
}

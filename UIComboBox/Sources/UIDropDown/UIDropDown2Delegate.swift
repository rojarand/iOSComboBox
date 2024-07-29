//
//  UIDropDown2Delegate.swift
//  Pods
//
//  Created by Robert Andrzejczyk on 10/08/2024.
//

import Foundation

public protocol UIDropDown2Delegate: AnyObject {
    func numberOfRows(in dropDown: UIDropDown2) -> Int
    func dropDown(_ dropDown2: UIDropDown2, objectValueForItemAt index: Int) -> Any?
    func dropDown(_ dropDown2: UIDropDown2, didSelectRowAt: IndexPath)
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

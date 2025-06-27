//
//  SampleTableView.swift
//  iOSComboBoxApp
//
//  Created by Robert Andrzejczyk on 12/10/2024.
//

import UIKit
import iOSComboBox

private let cellHeight = 100.0

class SampleTableView: UITableView, UITableViewDelegate, UITableViewDataSource  {
    
    private var items: [ListItem] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUp()
    }
    
    private func setUp() {
        register(TextCell.self, forCellReuseIdentifier: TextCell.identifier)
        register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.identifier)
        register(ComboBoxCell.self, forCellReuseIdentifier: ComboBoxCell.identifier)
        
        delegate = self
        dataSource = self
        items = createItems()
    }
    
    private func createItems() -> [ListItem] {
        var items = [
            ListItem(type: .button(title: "Scroll up") { [weak self] in
                self?.scrollUp(after: 1.5)
            }),
        ]
        
        items.append(ListItem(type: .text("")))
        items.append(ListItem(type: .comboBox(["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"])))
        //add some cells to make the table scrollable
        for i in 1...20 {
            items.append(ListItem(type: .text("")))
        }
        return items
    }
    
    private var indexOfComboBoxCell: Int {
        items.firstIndex { if case .comboBox(_) = $0.type { true } else { false } } ?? 0
    }
    
    private func scrollUp(after timeInterval: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) { [weak self] in
            self?.scrollUp()
        }
    }
    
    private func scrollUp() {
        let indexPath = IndexPath(row: indexOfComboBoxCell, section: 0)
        scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        switch item.type {
        case .text(let text):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.identifier, for: indexPath) as! TextCell
            cell.configure(with: text)
            return cell
        case .button(let title, let action):
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.identifier, for: indexPath) as! ButtonCell
            cell.configure(with: title, action: action)
            return cell
        case .comboBox(let items):
            let cell = tableView.dequeueReusableCell(withIdentifier: ComboBoxCell.identifier, for: indexPath) as! ComboBoxCell
            cell.configure(with: items)
            return cell
        }
    }
    
    // UITableViewDelegate method for row height (optional)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }
}

// Enum to define different cell types
enum CellType {
    case text(String)
    case comboBox([String])
    case button(title: String, action: (()->Void)? = nil)
}

// Custom Model to hold data for each cell
struct ListItem {
    let type: CellType
}

// Text cell
class TextCell: UITableViewCell {
    static let identifier = "TextCell"
    
    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        // Add layout constraints
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        label.text = text
    }
}

// ComboBox cell
class ComboBoxCell: UITableViewCell, iOSComboBoxDataSource, iOSComboBoxDelegate {
    static let identifier = "ComboBox"
    
    private let comboBox = iOSComboBox()
    private var items: [String]!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        comboBox.translatesAutoresizingMaskIntoConstraints = false
        comboBox.borderStyle = .roundedRect
        comboBox.layer.borderWidth = 1.0
        comboBox.layer.borderColor = UIColor.gray.cgColor
        comboBox.layer.cornerRadius = 8.0
        comboBox.placeholder = "Enter text here"
        comboBox.accessibilityIdentifier = "TableComboBox"
        contentView.addSubview(comboBox)
        
        // Add layout constraints
        NSLayoutConstraint.activate([
            comboBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            comboBox.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with items: [String]) {
        self.items = items
        comboBox.comboBoxDataSource = self
        comboBox.comboBoxDelegate = self
    }
    
    func numberOfItems(in comboBox: iOSComboBox) -> Int {
        items.count
    }
    
    func comboBox(_ comboBox: iOSComboBox, objectValueForItemAt index: Int) -> Any? {
        items[index]
    }
}

// Button cell
class ButtonCell: UITableViewCell {
    static let identifier = "ButtonCell"
    
    private let button = UIButton(type: .system)
    private var action: (()->Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        
        // Add layout constraints
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        // Add action for button
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, action: (()->Void)?) {
        button.setTitle(title, for: .normal)
        self.action = action
    }
    
    @objc private func buttonTapped() {
        self.action?()
    }
}

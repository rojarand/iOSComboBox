//
//  ViewController.swift
//  UIComboBox
//
//  Created by Robert Andrzejczyk on 15/03/2024.
//

import UIKit
import UIComboBox

import UIKit


// ViewController
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView!
    private var items: [ListItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Initialize tableView
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Add constraints for tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Register cell types
        tableView.register(TextCell.self, forCellReuseIdentifier: TextCell.identifier)
        tableView.register(ImageCell.self, forCellReuseIdentifier: ImageCell.identifier)
        tableView.register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.identifier)
        tableView.register(ComboBoxCell.self, forCellReuseIdentifier: ComboBoxCell.identifier)
        
        // Set delegate and dataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        // Populate the items array with various cell types
        items = [
            ListItem(type: .button(title: "Wait & scroll up") { [weak self] in
                self?.scrollUp(after: 3.0)
            }),
            ListItem(type: .text("This is a text cell")),
            ListItem(type: .image(UIImage(systemName: "car")!)),
            ListItem(type: .comboBox(["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"])),
            ListItem(type: .text("Another text cell")),
            ListItem(type: .image(UIImage(systemName: "house")!)),
            ListItem(type: .button(title: "Click Here")),
            ListItem(type: .text("... and another text cell")),
            ListItem(type: .text("... and another text cell")),
            ListItem(type: .button(title: "I'm a button")),
        ]
        
        tableView.reloadData()
        
    }
    
    private func scrollUp(after timeInterval: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) { [weak self] in
            guard let self = self else { return }
            let indexPath = IndexPath(row: self.items.count-1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
    
    private func scrollUp() {
        let indexPath = IndexPath(row: self.items.count-1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
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
            
        case .image(let image):
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
            cell.configure(with: image)
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
        return 100 // Customize the row height as per your design
    }
}

// Enum to define different cell types
enum CellType {
    case text(String)
    case comboBox([String])
    case image(UIImage)
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
class ComboBoxCell: UITableViewCell, UIComboBoxDataSource, ComboBoxDelegate {
    static let identifier = "ComboBox"
    
    private let comboBox = UIComboBox()
    private var items: [String]!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        comboBox.translatesAutoresizingMaskIntoConstraints = false
        comboBox.borderStyle = .roundedRect
        comboBox.placeholder = "Enter text here"
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
    
    func numberOfItems(in comboBox: UIComboBox) -> Int {
        items.count
    }
    func comboBox(_ comboBox: UIComboBox, objectValueForItemAt index: Int) -> Any? {
        items[index]
    }
    
    func comboBox(_ comboBox: UIComboBox, didSelectRowAt index: Int) {
        comboBox.text = items[index]
    }
}

// Image cell
class ImageCell: UITableViewCell {
    static let identifier = "ImageCell"
    
    let customImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(customImageView)
        
        // Add layout constraints
        NSLayoutConstraint.activate([
            customImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            customImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            customImageView.widthAnchor.constraint(equalToConstant: 50),
            customImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage) {
        customImageView.image = image
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

//
//  ViewController.swift
//  UIComboBox
//
//  Created by Robert Andrzejczyk on 15/03/2024.
//

import UIKit
import UIComboBox

class ViewController: UIViewController {
    
    private var topComboBox = UIComboBox()
    private var bottomComboBox = UIComboBox()
    private var tableView = SampleTableView()
    private var items: [ListItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        topComboBox.placeholder = "Top ComboBox"
        topComboBox.accessibilityIdentifier = "TopComboBox"

        bottomComboBox.placeholder = "Bottom ComboBox"
        bottomComboBox.accessibilityIdentifier = "BottomComboBox"
        
        [topComboBox, bottomComboBox].forEach { comboBox in
            comboBox.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(comboBox)
            comboBox.borderStyle = .roundedRect
            comboBox.register(cell: CountryCell.self)
            comboBox.comboBoxDataSource = self
            comboBox.comboBoxDelegate = self
        }
        
        NSLayoutConstraint.activate([
            topComboBox.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topComboBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topComboBox.widthAnchor.constraint(equalToConstant: 200),
            
            tableView.topAnchor.constraint(equalTo: topComboBox.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomComboBox.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            bottomComboBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomComboBox.widthAnchor.constraint(equalToConstant: 200),
            bottomComboBox.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
        
        tableView.reloadData()
    }
}

let CountryData: [(flag: UIImage?, countryName: String)] =
[(UIImage(named: "flag-pl"), "Poland"),
 (UIImage(named: "flag-de"), "Germany"),
 (UIImage(named: "flag-ru"), "Russia"),
 (UIImage(named: "flag-it"), "Italy"),
 (UIImage(named: "flag-fr"), "France"),
 (UIImage(named: "flag-gr"), "Greece"),
 (UIImage(named: "flag-pt"), "Portugal"),
 (UIImage(named: "flag-cz"), "Czechia"),
 (UIImage(named: "flag-sa"), "Republic of South Africa"),
 (UIImage(named: "flag-cn"), "China"),
]

extension ViewController: UIComboBoxDataSource, ComboBoxDelegate {
    
    func comboBox(_ comboBox: UIComboBox, cellProvider: UITableViewCellProvider, cellForRowAt position: Int) -> UITableViewCell {
        let cell: CountryCell = cellProvider.dequeCell(atRow: position)
        let (flag, countrName) = CountryData[position]
        cell.configure(with: flag, countryName: countrName)
        return cell
    }
    
    func numberOfItems(in comboBox: UIComboBox) -> Int {
        CountryData.count
    }
    
    func comboBox(_ comboBox: UIComboBox, objectValueForItemAt index: Int) -> Any? {
        CountryData[index].countryName
    }
    
    func comboBox(_ comboBox: UIComboBox, heightForRowAt position: Int) -> CGFloat {
        30.0
    }
}


// Country cell
class CountryCell: UITableViewCell {
    private let countryFlagView = UIImageView()
    private let countryNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        countryFlagView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(countryFlagView)
        
        countryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(countryNameLabel)

        NSLayoutConstraint.activate([
            countryFlagView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            countryFlagView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            countryFlagView.heightAnchor.constraint(equalToConstant: 20),
            countryFlagView.widthAnchor.constraint(equalToConstant: 30),
            
            countryNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            countryNameLabel.leadingAnchor.constraint(equalTo: countryFlagView.trailingAnchor, constant: 5),
            countryNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with flag: UIImage?, countryName: String) {
        countryFlagView.image = flag
        countryNameLabel.text = countryName
    }
}

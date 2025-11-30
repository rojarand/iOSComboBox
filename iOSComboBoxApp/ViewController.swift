//
//  ViewController.swift
//  iOSComboBox
//
//  Created by Robert Andrzejczyk on 15/03/2024.
//

import iOSComboBox
import UIKit

class ViewController: UIViewController {
    private let minBottomOffset = 20.0
    private var topComboBox = iOSComboBox()
    private var bottomComboBox = iOSComboBox()
    private var tableView = SampleTableView()
    private var items: [ListItem] = []
    private var bottomLayoutConstraint: NSLayoutConstraint!

    // swiftlint:disable:next function_body_length
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        view.backgroundColor = .systemBackground

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        topComboBox.placeholder = "Top ComboBox"
        topComboBox.accessibilityIdentifier = "TopComboBox"

        bottomComboBox.placeholder = "Bottom ComboBox"
        bottomComboBox.accessibilityIdentifier = "BottomComboBox"

        for comboBox in [topComboBox, bottomComboBox] {
            comboBox.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(comboBox)
            comboBox.borderStyle = .roundedRect
            comboBox.layer.borderWidth = 1.0
            comboBox.layer.borderColor = UIColor.gray.cgColor
            comboBox.layer.cornerRadius = 8.0

            comboBox.register(cellClass: CountryCell.self)
            comboBox.comboBoxDataSource = self
            comboBox.comboBoxDelegate = self
        }

        bottomLayoutConstraint = bottomComboBox.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -minBottomOffset)

        let goToObjcExampleButton = UIButton(type: .system)
        goToObjcExampleButton.setTitle("Go To Objc + StoryBoard example", for: .normal)
        goToObjcExampleButton.addTarget(self, action: #selector(goToObjcExample), for: .touchUpInside)
        goToObjcExampleButton.translatesAutoresizingMaskIntoConstraints = false
        goToObjcExampleButton.layer.borderWidth = 2.0
        goToObjcExampleButton.layer.borderColor = UIColor.systemBlue.cgColor
        goToObjcExampleButton.layer.cornerRadius = 8.0
        goToObjcExampleButton.clipsToBounds = true
        view.addSubview(goToObjcExampleButton)

        let openSwiftUiExampleButton = UIButton(type: .system)
        openSwiftUiExampleButton.setTitle("Open SwiftUi example", for: .normal)
        openSwiftUiExampleButton.addTarget(self, action: #selector(openSwiftUiExample), for: .touchUpInside)
        openSwiftUiExampleButton.translatesAutoresizingMaskIntoConstraints = false
        openSwiftUiExampleButton.layer.borderWidth = 2.0
        openSwiftUiExampleButton.layer.borderColor = UIColor.systemBlue.cgColor
        openSwiftUiExampleButton.layer.cornerRadius = 8.0
        openSwiftUiExampleButton.clipsToBounds = true
        view.addSubview(openSwiftUiExampleButton)

        NSLayoutConstraint.activate([
            goToObjcExampleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            goToObjcExampleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            goToObjcExampleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            goToObjcExampleButton.heightAnchor.constraint(equalToConstant: 30),

            openSwiftUiExampleButton.topAnchor.constraint(equalTo: goToObjcExampleButton.bottomAnchor, constant: 20),
            openSwiftUiExampleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            openSwiftUiExampleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            openSwiftUiExampleButton.heightAnchor.constraint(equalToConstant: 30),

            topComboBox.topAnchor.constraint(equalTo: openSwiftUiExampleButton.bottomAnchor, constant: 20),
            topComboBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topComboBox.widthAnchor.constraint(equalToConstant: 200),

            tableView.topAnchor.constraint(equalTo: topComboBox.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            bottomComboBox.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            bottomComboBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomComboBox.widthAnchor.constraint(equalToConstant: 200),
            bottomLayoutConstraint,
        ])

        tableView.reloadData()
    }

    @objc private func goToObjcExample() {
        let objcExampleVC = ObjcViewController()
        navigationController?.pushViewController(objcExampleVC, animated: false)
    }

    @objc private func openSwiftUiExample() {
        let swiftUiExample = ViewControllerWithSwitftUiContent()
        navigationController?.present(swiftUiExample, animated: true)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        bottomLayoutConstraint.constant = -keyboardFrame.height - minBottomOffset
    }

    @objc private func keyboardWillHide(_: Notification) {
        bottomLayoutConstraint.constant = -minBottomOffset
    }
}

let countryData: [(flag: UIImage?, countryName: String)] =
    [
        (UIImage(named: "flag-pl"), "Poland"),
        (UIImage(named: "flag-de"), "Germany"),
        (UIImage(named: "flag-ru"), "Russia"),
        (UIImage(named: "flag-it"), "Italy"),
        (UIImage(named: "flag-cn"), "China"),
        (UIImage(named: "flag-fr"), "France"),
        (UIImage(named: "flag-gr"), "Greece"),
        (UIImage(named: "flag-pt"), "Portugal"),
        (UIImage(named: "flag-cz"), "Czechia"),
        (UIImage(named: "flag-sa"), "Republic of South Africa"),
    ]

extension ViewController: iOSComboBoxDataSource, iOSComboBoxDelegate {
    func comboBox(_: iOSComboBox, cellProvider: UITableViewCellProvider, forRowAt index: Int) -> UITableViewCell {
        let cell: CountryCell = cellProvider.dequeCell(atRow: index)
        let (flag, countrName) = countryData[index]
        cell.configure(with: flag, countryName: countrName)
        cell.accessibilityTraits = [.button]
        return cell
    }

    func numberOfItems(in _: iOSComboBox) -> Int {
        countryData.count
    }

    func comboBox(_: iOSComboBox, objectValueForItemAt index: Int) -> Any? {
        countryData[index].countryName
    }

    func comboBox(_: iOSComboBox, heightForRowAt _: Int) -> CGFloat {
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

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with flag: UIImage?, countryName: String) {
        countryFlagView.image = flag
        countryNameLabel.text = countryName
    }
}

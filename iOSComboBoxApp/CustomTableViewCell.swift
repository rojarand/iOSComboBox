//
//  CustomTableViewCell.swift
//  iOSComboBoxApp
//
//  Created by Robert Andrzejczyk on 25/07/2024.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    private lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .gray.withAlphaComponent(0.4)
        return textField
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .yellow.withAlphaComponent(0.4)
        contentView.addSubview(indexLabel)
        let indexLabelConstraints = [
            indexLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            indexLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ]
        NSLayoutConstraint.activate(indexLabelConstraints)

        textField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textField)
        let textViewConstraints = [
            textField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textField.widthAnchor.constraint(equalToConstant: 200),
        ]
        NSLayoutConstraint.activate(textViewConstraints)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(text: String, index: Int) {
        textLabel?.text = text
        indexLabel.text = "\(index + 1)"
    }
}

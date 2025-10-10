//
//  IncomeExpenseCell.swift
//  BusFoYo
//
//  Created by Stepan on 09.10.2025.
//


import UIKit


class IncomeExpenseCell: UITableViewCell {
    let nameLabel = UILabel()
    let amountLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.textAlignment = .right

        contentView.addSubview(nameLabel)
        contentView.addSubview(amountLabel)

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            amountLabel.widthAnchor.constraint(equalToConstant: 100),

            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -8)
        ])

        nameLabel.font = UIFont.systemFont(ofSize: 13)
        amountLabel.font = UIFont.systemFont(ofSize: 13)
        layer.cornerRadius = 12
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

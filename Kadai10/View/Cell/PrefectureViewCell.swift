//
//  PrefectureViewCell.swift
//  Kadai10
//
//  Created by daiki umehara on 2021/09/11.
//

import UIKit

class PrefectureViewCell: UITableViewCell {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var discriptionLabel: UILabel!

    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }

    func configure(name: String, index: Int, color: UIColor) {
        nameLabel.text = name
        discriptionLabel.text = "\(index)番目の都道府県です"
        self.backgroundColor = color
    }
}

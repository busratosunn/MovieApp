//
//  SettingsTableViewCell.swift
//  Movie App 2
//
//  Created by Gülhan Büşra TOSUN on 2.05.2025.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var settingsImageView: UIImageView!
    @IBOutlet weak var settingsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with iconName: String, title: String) {
        settingsImageView.image = UIImage(systemName: iconName)
        settingsLabel.text = title
    }

}


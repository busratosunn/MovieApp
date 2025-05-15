//
//  SettingsViewController.swift
//  Movie App 2
//
//  Created by Gülhan Büşra TOSUN on 2.05.2025.
//

import UIKit

class SettingsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    let settingsItems: [SettingsItem] = [
        SettingsItem(title: "Account", iconName: "friends"),
        SettingsItem(title: "Privacy", iconName: "friends"),
        SettingsItem(title: "Appearance", iconName: "friends"),
        SettingsItem(title: "Notifications", iconName: "friends"),
        SettingsItem(title: "Storage", iconName: "friends"),
        SettingsItem(title: "Accessibility", iconName: "friends"),
        SettingsItem(title: "Help", iconName: "friends")
    ]
    let settingsData: [SettingsItem] = [
        SettingsItem(title: "Account", iconName: "person"),
        SettingsItem(title: "Privacy", iconName: "lock"),
        SettingsItem(title: "Appearance", iconName: "paintbrush"),
        SettingsItem(title: "Notifications", iconName: "bell"),
        SettingsItem(title: "Storage", iconName: "internaldrive"),
        SettingsItem(title: "Accessibility", iconName: "figure.walk"),
        SettingsItem(title: "Help", iconName: "questionmark")
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.backgroundColor = .clear
    }
}

extension SettingsViewController: UITableViewDelegate {
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingsTableViewCell
        let veri = settingsData[indexPath.row]
        let settings = settingsItems[indexPath.row]
        cell.settingsLabel.text = settings.title
        cell.settingsImageView.image = UIImage(named: settings.iconName)
        cell.configure(with: veri.iconName, title: veri.title)
        cell.backgroundColor = .clear
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


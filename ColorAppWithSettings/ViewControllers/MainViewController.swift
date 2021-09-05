//
//  MainViewController.swift
//  ColorAppWithSettings
//
//  Created by Mary Jane on 04.09.2021.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func updateBackgroundColor(with color: UIColor)
}

class MainViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsViewController else { return }
        settingsVC.bgcolor = view.backgroundColor
        settingsVC.delegate = self
    }
}

extension MainViewController: SettingsViewControllerDelegate {
    func updateBackgroundColor(with color: UIColor) {
        view.backgroundColor = color
        navigationController?.navigationBar.barTintColor = color
    }
}



//
//  BaseViewController.swift
//  Movie App 2
//
//  Created by Gülhan Büşra TOSUN on 2.05.2025.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        
    }
    private func setGradientBackground() {
           let colorTop = UIColor.white.cgColor
           let colorBottom = UIColor.systemTeal.cgColor

           let gradientLayer = CAGradientLayer()
           gradientLayer.colors = [colorTop, colorBottom]
           gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
           gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
           gradientLayer.frame = view.bounds

           view.layer.insertSublayer(gradientLayer, at: 0)
       }
}

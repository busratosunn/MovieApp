//
//  WebViewController.swift
//  Movie App 2
//
//  Created by Gülhan Büşra TOSUN on 2.05.2025.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var url: String?
    private var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Geri butonu
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain,target: self, action: #selector(closeWebView))
        backButton.tintColor = .white// veya başka bir renk
        navigationItem.leftBarButtonItem = backButton
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Geri", style: .plain, target: self, action: #selector(closeWebView))
        
        if let urlString = url, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            print("Geçersiz URL")
        }
    }
    
    @objc private func closeWebView() {
        navigationController?.popViewController(animated: true)
    }
}



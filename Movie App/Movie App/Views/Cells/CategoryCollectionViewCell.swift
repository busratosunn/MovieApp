//
//  CategoryCollectionViewCell.swift
//  Movie App 2
//
//  Created by Gülhan Büşra TOSUN on 2.05.2025.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    static let identifier = "CategoryCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        
        // Gölgelendirme
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        // Köşe yuvarlama
        categoryView.cornerRadius = 12
        categoryView.layer.masksToBounds = true
    }

    // Seçili kategori rengi
    override var isSelected: Bool {
        didSet {
            categoryLabel.textColor = isSelected ? UIColor.systemTeal : UIColor.black
        }
    }
}

// MARK: - Köşe yuvarlama için uzantı
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
        }
    }
}

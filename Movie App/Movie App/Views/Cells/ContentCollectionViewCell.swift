//
//  ContentCollectionViewCell.swift
//  Movie App 2
//
//  Created by Gülhan Büşra TOSUN on 2.05.2025.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var contentImage: UIImageView!
    
    static let identifier = "ContentCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ContentCollectionViewCell", bundle: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentImage.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear

        // Görsel boyutları için düzeltme burada
        contentImage.contentMode = .scaleAspectFill
        contentImage.clipsToBounds = true
    }
    
    public func configure(with contentModel: ContentModel) {
        self.contentImage.image = UIImage(named: contentModel.imageName)
    }
//    func configure(with movie: SearchMovie) {
//            if let posterPath = movie.posterPath {
//                let imageUrlString = "https://image.tmdb.org/t/p/w500\(posterPath)"
//                if let url = URL(string: imageUrlString) {
//                    URLSession.shared.dataTask(with: url) { data, _, _ in
//                        if let data = data {
//                            DispatchQueue.main.async {
//                                self.contentImage.image = UIImage(data: data)
//                            }
//                        }
//                    }.resume()
//                }
//            }
//        }
    }

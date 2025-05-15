//
//  DetailsViewController.swift
//  Movie App 2
//
//  Created by Gülhan Büşra TOSUN on 2.05.2025.
//

import UIKit

class DetailsViewController: BaseViewController {
    // Zorunlu init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // IBOutlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    
    var selectedContent: Result?
    var movieDetail: MovieDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        setupWatchTrailerButton(overviewLabel: overviewLabel)
        
        if let content = selectedContent {
            print("🆔 Seçilen ID: \(content.id ?? -1)")
            fetchMovieDetails(movieID: content.id ?? 0)
        }    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCustomBackButton()
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // MARK: - UI Setup Functions
    private func setupUI() {
        guard let detail = movieDetail else { return }
        if let posterPath = detail.posterPath,
           let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)"),
           let data = try? Data(contentsOf: url) {
            
            posterImageView.image = UIImage(data: data)
            posterImageView.layer.cornerRadius = 30
            posterImageView.clipsToBounds = true
            posterImageView.alpha = 0
            
            UIView.animate(withDuration: 0.5) {
                self.posterImageView.alpha = 1
            }
        }
        titleLabel.text = detail.originalTitle
        titleLabel.font = UIFont(name: "Optima-Bold", size: 25)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7
        titleLabel.lineBreakMode = .byWordWrapping
        
        releaseDateLabel.text = "Release Date: \(detail.releaseDate ?? "N/A")"
        releaseDateLabel.textAlignment = .center
        releaseDateLabel.numberOfLines = 1
        releaseDateLabel.lineBreakMode = .byTruncatingTail
        releaseDateLabel.adjustsFontSizeToFitWidth = true
        releaseDateLabel.minimumScaleFactor = 0.5
        releaseDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        releaseDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        
        voteCountLabel.text = "Vote Count: \(detail.voteCount ?? 0)"
        voteCountLabel.textAlignment = .center
        
        overviewLabel.text = detail.overview
        overviewLabel.numberOfLines = 0
        overviewLabel.lineBreakMode = .byWordWrapping
        overviewLabel.textAlignment = .center
        
        // Navigation title
        navigationItem.backButtonTitle = ""
        navigationItem.title = detail.originalTitle
    }
    func fetchMovieDetails(movieID: Int) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)?language=en-US&api_key=7cd6a03d7564362029b431fe3835d68c"
        let model = Network<MovieDetail>.Model(urlString: urlString)
        let network = Network<MovieDetail>()
        network.request(model: model) { [ weak self ] detail in
            guard let self = self , let detail = detail else { return }
            
            DispatchQueue.main.async {
                self.movieDetail = detail
                self.setupUI()
            }
        }
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
    private func setupCustomBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain,target: self, action: #selector(customBackAction))
        backButton.tintColor = .black // veya başka bir renk
        navigationItem.leftBarButtonItem = backButton
    }
    @objc private func customBackAction() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupWatchTrailerButton(overviewLabel: UILabel) {
        let watchTrailerButton = UIButton(type: .system)
        watchTrailerButton.setTitle("🎥 Fragman İzle", for: .normal)
        watchTrailerButton.setTitleColor(.black, for: .normal)
        watchTrailerButton.backgroundColor = UIColor.white
        watchTrailerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        watchTrailerButton.layer.cornerRadius = 10
        watchTrailerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(watchTrailerButton)
        
        // Butonun Overview label altına yerleştirilmesi
        NSLayoutConstraint.activate([
            watchTrailerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            watchTrailerButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            watchTrailerButton.widthAnchor.constraint(equalToConstant: 200),
            watchTrailerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
        //         Button Action
        watchTrailerButton.addTarget(self, action: #selector(watchTrailerButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func watchTrailerButtonTapped() {
        guard let detail = movieDetail else { return }
        let webVC = WebViewController()
        webVC.url = detail.homepage
        navigationController?.pushViewController(webVC, animated: true)
    }
}

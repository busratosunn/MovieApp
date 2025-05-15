import UIKit
import SDWebImage

class ViewController: BaseViewController ,UISearchBarDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBOutlet weak var contentCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedCategoryIndex = "Trending"
    var filteredResults: [Result] = []
    var isSearching: Bool = false
    
    var safeResults: [Result] = [] {
        didSet {
            self.results = self.safeResults
        }
    }
    
    var results: [Result] = [] {
        didSet {
            DispatchQueue.main.async {
                self.contentCollectionView.delegate = self
                self.contentCollectionView.dataSource = self
                self.contentCollectionView.reloadData()
            }
        }
    }
    
    var categories: [Category] = [] {
        didSet {
            DispatchQueue.main.async {
                self.categoryCollectionView.delegate = self
                self.categoryCollectionView.dataSource = self
                self.categoryCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        categoryCollectionView.backgroundColor = .clear
        contentCollectionView.backgroundColor = .clear
        
        searchBar.delegate = self
        bind()
    }
    func bind() {
        let dispatchGroup = DispatchGroup()
        
        var fetchedResults: [Result] = []
        var fetchedCategories: [Category] = []
        
        dispatchGroup.enter()
        
        
        activityIndicator.startAnimating()
        
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        
        Network<ListResponse>()
            .request(model: .init(urlString: "https://api.themoviedb.org/3/discover/movie?language=en-US&page=1&api_key=7cd6a03d7564362029b431fe3835d68c")) { listResponse in
                guard let results = listResponse?.results, !results.isEmpty else { return }
                fetchedResults = results
                dispatchGroup.leave()
                
                
                DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                    // Başarılıysa 2 saniye sonra indicator'ı durdur
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.activityIndicator.stopAnimating()
                    }
                    
                }
            }
        
        dispatchGroup.enter()
        Network<CategoriesResponse>()
            .request(model: .init(urlString: "https://api.themoviedb.org/3/genre/movie/list?api_key=7cd6a03d7564362029b431fe3835d68c")) { categoriesResponse in
                guard let categories = categoriesResponse?.genres, !categories.isEmpty else { return }
                fetchedCategories = categories
                dispatchGroup.leave()
            }
        dispatchGroup.notify(queue: .main) {
            self.safeResults = fetchedResults
            
            self.categories = self.filterCategories(using: fetchedResults, from: fetchedCategories)
        }
    }
    func filterCategories(using results:[Result] , from categories: [Category]) -> [Category]{
        let allGenreIDsInResults: Set<Int> = Set(results.compactMap { $0.genreIDS}.flatMap {$0})
        
        return categories.filter { category in
            guard let id = category.id else { return false }
            return allGenreIDsInResults.contains(id)
            
        }
    }
    
    private func setupCollectionView() {
        categoryCollectionView.register(CategoryCollectionViewCell.nib(), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        contentCollectionView.register(ContentCollectionViewCell.nib(), forCellWithReuseIdentifier: ContentCollectionViewCell.identifier)
    }
    
    func filterMoviesBySearch(_ searchText: String) {
        var searchResults: [ContentModel] = []
        for category in categories {
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredResults = []
            results = self.safeResults
        } else {
            isSearching = true
            filteredResults = safeResults.filter { result in
                let lowercasedQuery = searchText.lowercased()
                return result.title?.lowercased().contains(lowercasedQuery) == true ||
                result.originalTitle?.lowercased().contains(lowercasedQuery) == true ||
                result.overview?.lowercased().contains(lowercasedQuery) == true
            }
            results = filteredResults
        }

        contentCollectionView.reloadData()
    }
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ selectedCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedCollectionView == categoryCollectionView {
            return categories.count
        } else if selectedCollectionView == contentCollectionView {
            return isSearching ? filteredResults.count : results.count
        }
        return 0
    }
    
    func collectionView(_ selectedCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectedCollectionView == categoryCollectionView {
            let cell = selectedCollectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
            
            let category = categories[indexPath.item]
            cell.categoryLabel.text = category.name
            return cell
        } else {
            let cell = selectedCollectionView.dequeueReusableCell(withReuseIdentifier: ContentCollectionViewCell.identifier, for: indexPath) as! ContentCollectionViewCell
            let selectedResult = isSearching ? filteredResults[indexPath.item] : results[indexPath.item]
            let transformer = SDImageResizingTransformer(size: cell.frame.size, scaleMode: .aspectFill)
            cell.contentImage.sd_setImage(
                with: URL(string: "https://image.tmdb.org/t/p/original/" + (selectedResult.posterPath ?? "")), placeholderImage: nil,context: [.imageTransformer: transformer])
            cell.contentImage.contentMode = .scaleAspectFill
            cell.contentImage.clipsToBounds = true
            
            return cell
        }
    }
    
    func collectionView(_ selectedCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedCollectionView == categoryCollectionView {
            let selectedCategory = categories[indexPath.item]
            
            let selectedResults = safeResults.filter({ $0.genreIDS?.contains(where: { $0 == selectedCategory.id }) ?? false })
            
            self.results = selectedResults
            
        } else if selectedCollectionView == contentCollectionView {
            let selectedMovie = results[indexPath.row] // veya section yapısına göre değişebilir
            let detailVC = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
                detailVC.selectedContent = selectedMovie
                navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.contentCollectionView {
            let edgeInsets: CGFloat = 16 // sol ve sağ boşluk
            let interItemSpacing: CGFloat = 10 // hücreler arası boşluk
            let totalSpacing = edgeInsets * 2 + interItemSpacing
            let columns: CGFloat = 2
            let width = (collectionView.frame.width - totalSpacing) / columns
            return CGSize(width: width, height: width * 1.5)
        } else if collectionView == self.categoryCollectionView {
            return CGSize(width: 100, height: 50)
        }

        return CGSize(width: 100, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == contentCollectionView {
                return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            } else if collectionView == categoryCollectionView {
                return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8) // daha küçük boşluk
            }
            return .zero
    }
}

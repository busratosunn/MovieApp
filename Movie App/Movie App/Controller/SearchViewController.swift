import UIKit
import SDWebImage

class SearchViewController: BaseViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsCollectionView: UICollectionView!
    var filteredContents: [SearchMovie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.searchTextField.backgroundColor = UIColor.systemGray5
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        resultsCollectionView.backgroundColor = .clear
        resultsCollectionView.delegate = self
        resultsCollectionView.dataSource = self
        resultsCollectionView.contentMode = .left
        resultsCollectionView.register(ContentCollectionViewCell.nib(), forCellWithReuseIdentifier: ContentCollectionViewCell.identifier)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            self.filteredContents = []
            self.resultsCollectionView.reloadData()
            return
        }
        searchMovies(with: searchText)
        func searchMovies(with query: String) {
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let urlString = "https://api.themoviedb.org/3/search/movie?api_key=7cd6a03d7564362029b431fe3835d68c&query=\(encodedQuery)"
            let model = Network<SearchResponse>.Model(urlString: urlString)
            Network<SearchResponse>().request(model: model) { response in
                DispatchQueue.main.async {
                    self.filteredContents = (response?.results ?? []).filter { $0.posterPath != nil }
                        self.resultsCollectionView.reloadData()
                    }
        }
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredContents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCollectionViewCell.identifier, for: indexPath) as! ContentCollectionViewCell
        let movie = filteredContents[indexPath.item]
        print("Poster path: \(movie.posterPath ?? "nil")")
        let transformer = SDImageResizingTransformer(size: cell.frame.size, scaleMode: .aspectFill)
        cell.contentImage.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/original/" + (movie.posterPath ?? "")), placeholderImage: nil,context: [.imageTransformer: transformer])
        return cell
    }
}
 

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (collectionView.frame.width / 2) - 24  // örnek: 2 sütun
            let height = width * 1.5 // poster oranı genelde 2:3
            return CGSize(width: width, height: height)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if filteredContents.count == 1 {
            // Tek bir hücre varsa sola yasla
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: UIScreen.main.bounds.width / 2)
        } else {
            // Normalde kenarlardan eşit boşluk
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}

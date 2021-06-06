import UIKit
import SnapKit

class SearchQuizViewController: UIViewController {
    
    let cellIdentifier = "cellId"
    let headerID = "Header"
    let backgroundColor = UIColor.systemBlue
    
    var searchBar: UISearchBar!
    var collectionView: UICollectionView!
    
    var dataService = NetworkService()
    let quizUseCase: QuizUseCase
    var quizzes: [String: [QuizViewModel]] = [:]
    var categories: [String] = []
    
    let router: AppRouterProtocol
    
    init(router: AppRouterProtocol, useCase: QuizUseCase) {
        self.router = router
        self.quizUseCase = useCase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterQuizzes()
        
        buildView()
        defineLayoutForViews()
        styleView()
        do {
            try refreshQuizzes()
        } catch {
            DispatchQueue.main.async { [weak self] in
                let alert = UIAlertController(title: "No internet connection!", message: "Could not load new quizzes.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    private func defineLayoutForViews() {
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(60)
        }
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func buildView() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.placeholder = "Search quizzes"
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.headerReferenceSize = CGSize(width: 200, height: 50)
        
        collectionView = UICollectionView(frame:.zero, collectionViewLayout: flowLayout)
        view.addSubview(collectionView)
        
        collectionView.register(QuizCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerID)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func refreshQuizzes() throws {
        try quizUseCase.refreshData() { [weak self] in
            self?.filterQuizzes()
        }
    }
    
    private func filterQuizzes(filter: FilterSettings? = nil) {
        let array = quizUseCase.getQuizzes(filter: filter).map { QuizViewModel($0)}
        quizzes = Dictionary(grouping: array, by: { $0.category })
        categories = Array(self.quizzes.keys).sorted()
       
        DispatchQueue.main.async {
            self.collectionView.backgroundColor = .white
            self.collectionView.reloadData()
        }
    }
    
    
    
    
    private func styleView() {
        view.backgroundColor = backgroundColor
        
        collectionView.backgroundColor = backgroundColor
    }
}

extension SearchQuizViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categories.count == 0 {
            return 0
        }
        return quizzes[categories[section]]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath) as! QuizCell
        let quiz = quizzes[categories[indexPath.section]]?[indexPath.row]
        
        let image = quiz?.image
        cell.quiz = quiz
        cell.image = image
        return cell
    }
    
    func numberOfSections(in tableView: UICollectionView) -> Int {
        quizzes.keys.count
        
    }
    
    func collectionView(_ tableView: UICollectionView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].uppercased()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var v : UICollectionReusableView! = nil
        if kind == UICollectionView.elementKindSectionHeader {
            v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID, for: indexPath)
            if v.subviews.count == 0 {
                v.addSubview(UILabel(frame:CGRect(x: 0,y: 5,width: 200,height: 40)))
            }
            let lab = v.subviews[0] as! UILabel
            lab.text = categories[indexPath.section].uppercased()
            lab.font = lab.font.withSize(30)
            lab.textAlignment = .center
        }
        return v
    }
    
}

extension SearchQuizViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let quiz = quizzes[categories[indexPath.section]]?[indexPath.row] else { return }
        router.showQuizController(quiz: quiz)
    }
}

extension SearchQuizViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                            UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
}

extension SearchQuizViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let filter = FilterSettings(searchText: searchBar.text)

        filterQuizzes(filter: filter)
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let filter = FilterSettings(searchText: searchBar.text)

        filterQuizzes(filter: filter)
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let filter = FilterSettings(searchText: searchBar.text)

        filterQuizzes(filter: filter)
        collectionView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filter = FilterSettings(searchText: searchBar.text)
        
        filterQuizzes(filter: filter)
        collectionView.reloadData()
    }
}


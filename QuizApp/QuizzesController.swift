import UIKit
import SnapKit

class QuizzesController: UIViewController {
    
    let cellIdentifier = "cellId"
    let headerID = "Header"
    let backgroundColor = UIColor.systemBlue
    
    var factLabel: UILabel!
    var factText: UILabel!
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
        getQuizzes()

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
        factLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(50)
        }
        
        factText.snp.makeConstraints {
            $0.top.equalTo(factLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(50)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(factText.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }        
    }
    
    private func buildView() {
        factLabel = UILabel()
        factLabel.text = "Fun Fact"
        factLabel.font = factLabel.font.withSize(30)
        view.addSubview(factLabel)
        
        factText = UILabel()
        factText.numberOfLines = 4
        view.addSubview(factText)
        
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
            self?.getQuizzes()
        }
    }
    
    @objc private func getQuizzes() {
        let array = quizUseCase.getQuizzes().map { QuizViewModel($0)}
        quizzes = Dictionary(grouping: array, by: { $0.category })
        categories = Array(self.quizzes.keys).sorted()
        let factNumber = array
            .flatMap { $0.questions }
            .map { $0.question }
            .filter { $0.contains("NBA")}
            .count
        DispatchQueue.main.async {
            self.collectionView.backgroundColor = .white
            
            self.factText.text = "There are \(factNumber) questions that contain the word \"NBA\""
            
            self.collectionView.reloadData()
        }
    }
        
    
   
    
    private func styleView() {
        view.backgroundColor = backgroundColor
        
        collectionView.backgroundColor = backgroundColor
    }
}

extension QuizzesController: UICollectionViewDataSource {
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

extension QuizzesController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let quiz = quizzes[categories[indexPath.section]]?[indexPath.row] else { return }
        router.showQuizController(quiz: quiz)
    }
}

extension QuizzesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                            UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
}

class QuizCell: UICollectionViewCell {
    let quizDescription: UILabel = {
        let qd = UILabel()
        qd.numberOfLines = 3
        return qd
    }()
    var quizImage: UIImageView = {
        let qi = UIImageView()
        qi.translatesAutoresizingMaskIntoConstraints = false
        qi.contentMode = .scaleAspectFill
        qi.clipsToBounds = true
        return qi
    }()
    var quizTitle: UILabel = {
        let qt = UILabel()
        qt.font = qt.font.withSize(23)
        qt.numberOfLines = 0
        return qt
    }()
    
    var quiz: QuizViewModel? {
        didSet {
            guard quiz != nil else { return }
            quizDescription.text = quiz?.description
            quizTitle.text = quiz?.title
        }
    }
    var image: UIImage? {
        didSet {
            guard let image = image else {return}
            quizImage.image = image
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: .zero)
        
        buildView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildView() {
        contentView.addSubview(quizImage)
        contentView.addSubview(quizDescription)
        contentView.addSubview(quizTitle)
        
        
        quizImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(5)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(10)
            $0.width.equalTo(100)
        }
        
        quizTitle.snp.makeConstraints {
            $0.leading.equalTo(quizImage.snp.trailing).offset(5)
            $0.top.equalToSuperview().offset(5)
            $0.height.equalTo(55)
            $0.trailing.equalToSuperview().offset(5)
        }
        
        quizDescription.snp.makeConstraints {
            $0.leading.equalTo(quizTitle.snp.leading)
            $0.top.equalTo(quizTitle.snp.bottom).offset(5)
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
}


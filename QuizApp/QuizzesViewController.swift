import UIKit
import SnapKit

class QuizzesViewController: UIViewController {
    
    let cellIdentifier = "cellId"
    let headerID = "Header"
    let backgroundColor = UIColor.systemBlue
    
    var loadButton: UIButton!
    var factLabel: UILabel!
    var factText: UILabel!
    var collectionView: UICollectionView!
    
    var dataService = DataService()
    var quizzes: [String: [Quiz]] = [:]
    var categories: [QuizCategory] = []
    
    let router: AppRouterProtocol
    
    init(router: AppRouterProtocol) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildView()
        defineLayoutForViews()
        styleView()
    }
    
    private func defineLayoutForViews() {
        loadButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(40)
        }
        loadButton.layer.cornerRadius = 20
        
        factLabel.snp.makeConstraints {
            $0.top.equalTo(loadButton.snp.bottom).offset(20)
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
            $0.leading.trailing.equalToSuperview().inset(10)
        }        
    }
    
    private func buildView() {
        loadButton = UIButton()
        view.addSubview(loadButton)
        loadButton.setTitle("Get Quiz", for: .normal)
        loadButton.addTarget(self, action: #selector(loadQuizzes), for: .touchUpInside)
        
        factLabel = UILabel()
        factLabel.text = "Fun Fact"
        factLabel.font = factLabel.font.withSize(30)
        view.addSubview(factLabel)
        
        factText = UILabel()
        factText.numberOfLines = 4
        view.addSubview(factText)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.headerReferenceSize = CGSize(width: 200, height: 40)
        
        collectionView = UICollectionView(frame:.zero, collectionViewLayout: flowLayout)
        view.addSubview(collectionView)
        
        collectionView.register(QuizCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerID)

        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc private func loadQuizzes() {
        collectionView.backgroundColor = .white
        let quizArray = dataService.fetchQuizes()
        quizzes = Dictionary()
        
        for quiz in quizArray {
            if quizzes[quiz.category.rawValue] == nil {
                quizzes[quiz.category.rawValue] = Array()
            }
            quizzes[quiz.category.rawValue]?.append(quiz)
        }
        
        categories = Array(Set(quizArray.map({$0.category}))).sorted(by: {$0.rawValue > $1.rawValue})
        
        let factNumber = quizArray
            .flatMap { $0.questions }
            .map { $0.question }
            .filter { $0.contains("NBA")}
            .count
        
        factText.text = "There are \(factNumber) questions that contain the word \"NBA\""
        
        collectionView.reloadData()
    }
    
    private func styleView() {
        view.backgroundColor = backgroundColor
        
        loadButton.backgroundColor = .white
        loadButton.setTitleColor(backgroundColor, for: .normal)
        
        collectionView.backgroundColor = backgroundColor
    }
}

extension QuizzesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        quizzes[categories[section].rawValue]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath) as! QuizCell
        let quiz = quizzes[categories[indexPath.section].rawValue]?[indexPath.row]
        
        let image = [UIImage(systemName: "questionmark.square.fill"), UIImage(systemName: "questionmark.square")][indexPath.row % 2]
        cell.quiz = quiz
        cell.image = image
        return cell
    }
    
    func numberOfSections(in tableView: UICollectionView) -> Int {
        quizzes.keys.count
        
    }
    
    func collectionView(_ tableView: UICollectionView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].rawValue.uppercased()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var v : UICollectionReusableView! = nil
        if kind == UICollectionView.elementKindSectionHeader {
            v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID, for: indexPath)
            if v.subviews.count == 0 {
                v.addSubview(UILabel(frame:CGRect(x: 0,y: 0,width: 200,height: 40)))
            }
            let lab = v.subviews[0] as! UILabel
            lab.text = categories[indexPath.section].rawValue.uppercased()
            lab.font = lab.font.withSize(30)
            lab.textAlignment = .center
        }
        return v
    }
    
}

extension QuizzesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let quiz = quizzes[categories[indexPath.section].rawValue]?[indexPath.row] else { return }
        router.showQuizController(quiz: quiz)
        // Logic when cell is selected
    }
}

extension QuizzesViewController: UICollectionViewDelegateFlowLayout {
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
    
    var quiz: Quiz? {
        didSet {
            guard quiz != nil else { return }
            quizDescription.text = quiz!.description  + "\n" + String(quiz?.level ?? 0) + "/3"
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


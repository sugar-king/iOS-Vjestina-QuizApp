import Foundation
import UIKit

class LeaderboardController : UIViewController {
    let cellIdentifier = "leaderborderCell"
    let router: AppRouterProtocol
    let networkService: NetworkServiceProtocol = NetworkService()
    
    let quizId: Int
    var results = [LeaderboardResult]()
    
    var boardLabel: UILabel!
    var closeButton: UIButton!
    var table: UITableView!
    
    init(router: AppRouterProtocol, quizId: Int) {
        self.router  = router
        self.quizId = quizId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        buildViews()
    }
    
    func buildViews() {
        view.backgroundColor = .systemBlue
        
        boardLabel = UILabel()
        boardLabel.text = "Leaderboard"
        boardLabel.textColor = .white
        boardLabel.font = boardLabel.font.withSize(30)
        view.addSubview(boardLabel)
        
        boardLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.centerX.equalToSuperview()
        }
        
        closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(hideLeaderborder), for: .touchUpInside)
        view.addSubview(closeButton)
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(boardLabel.snp.top)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        table = UITableView()
        view.addSubview(table)
        table.allowsSelection = false
        table.isScrollEnabled = false
        table.separatorColor = .white
        table.backgroundColor = .systemBlue
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        let headerView = UIView()
        table.tableHeaderView = headerView

        headerView.backgroundColor = .systemBlue
        headerView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        
        table.dataSource = self
        table.snp.makeConstraints {
            $0.top.equalTo(boardLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        networkService.fetchLeaderboard(quizId: quizId) { [weak self] results, error in
            guard let results = results, let self = self else { return }
            self.results = Array(results
                                    .sorted(by: {Double($0.score ?? "0")! > Double($1.score ?? "0")!})
                                    .prefix(10))
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
        
        if let headerView = table.tableHeaderView {
            let playerLabel = UILabel()
            playerLabel.text = "Player"
            playerLabel.textColor = .white
            playerLabel.font = playerLabel.font.withSize(25)
            headerView.addSubview(playerLabel)
            playerLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(5)
                $0.leading.equalToSuperview().offset(10)
            }
            
            let pointsLabel = UILabel()
            pointsLabel.text = "Points"
            pointsLabel.textColor = .white
            pointsLabel.font = pointsLabel.font.withSize(25)
            headerView.addSubview(pointsLabel)
            pointsLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(5)
                $0.trailing.equalToSuperview().inset(10)
            }
            
        }
    }
    
    
    @objc
    private func hideLeaderborder(_ sender: UIButton) {
        router.hideLeaderborder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.rowHeight = table.bounds.height / 11
    }
}

extension LeaderboardController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier,
            for: indexPath)
        var cellConfig: UIListContentConfiguration = cell.defaultContentConfiguration()
        cellConfig.text = "\(indexPath.row + 1). \(results[indexPath.row].username)"
        cellConfig.textProperties.color = .white
        cellConfig.secondaryText = "\(results[indexPath.row].score ?? "0.0")"
        cellConfig.secondaryTextProperties.color = .white
        cellConfig.prefersSideBySideTextAndSecondaryText = true
        cell.backgroundColor = .systemBlue
        cell.contentConfiguration = cellConfig
        return cell
    }
    
    
}

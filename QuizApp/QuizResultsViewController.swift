import Foundation
import UIKit

class QuizResultsViewController : UIViewController {
    let router: AppRouterProtocol
    let networkService: NetworkServiceProtocol = NetworkService()
    
    let quizId: Int
    let correct: Int
    let total: Int
    let time: TimeInterval
    
    var resultsLabel: UILabel!
    var leaderboardButton: UIButton!
    var finishButton: UIButton!
    
    init(router: AppRouterProtocol, quizId: Int, correct: Int, of: Int, time: TimeInterval) {
        self.quizId = quizId
        self.correct = correct
        self.total = of
        self.router = router
        self.time = time
        super.init(nibName: nil, bundle: nil)
        
        networkService.uploadQuizResults(quizResult: QuizResult(quizId: quizId, userId: UserDefaults.standard.integer(forKey: "user_id"), time: time, noOfCorrect:    correct))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBlue
        
        resultsLabel = UILabel()
        resultsLabel.text = "\(correct) out of \(total)"
        resultsLabel.font = resultsLabel.font.withSize(50)
        resultsLabel.numberOfLines = 0
        
        view.addSubview(resultsLabel)
        
        resultsLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(300)
            $0.width.lessThanOrEqualToSuperview().inset(10)
            $0.centerX.equalToSuperview()
        }
        
        leaderboardButton = UIButton()
        leaderboardButton.setTitle("See leaderboard", for: .normal)
        leaderboardButton.addTarget(self, action: #selector(showLeaderboard), for: .touchUpInside)
        leaderboardButton.backgroundColor = .white
        leaderboardButton.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(leaderboardButton)
        
        leaderboardButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(150)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(50)
            $0.height.equalTo(60)
        }
        leaderboardButton.layer.cornerRadius = 30
        
        finishButton = UIButton()
        finishButton.setTitle("Finish Quiz", for: .normal)
        finishButton.addTarget(self, action: #selector(finishQuiz), for: .touchUpInside)
        finishButton.backgroundColor = .white
        finishButton.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(finishButton)
        
        
        finishButton.snp.makeConstraints {
            $0.top.equalTo(leaderboardButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(50)
            $0.height.equalTo(60)
        }
        finishButton.layer.cornerRadius = 30
    }
    @objc
    func finishQuiz(_ sender: UIButton) {
        router.returnToHomeController()
    }
    
    @objc
    func showLeaderboard(_ sender: UIButton) {
        router.showLeaderborder(quizId: quizId)
    }
}

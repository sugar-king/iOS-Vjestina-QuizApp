import Foundation
import UIKit

class QuizResultsViewController : UIViewController {
    let router: AppRouterProtocol
    let correct: Int
    let total: Int
    
    var resultsLabel: UILabel!
    var finishButton: UIButton!
    
    
    init(correct: Int, of: Int, router: AppRouterProtocol) {
        self.correct = correct
        self.total = of
        self.router = router
        super.init(nibName: nil, bundle: nil)
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
        
        finishButton = UIButton()
        finishButton.setTitle("Finish Quiz", for: .normal)
        finishButton.addTarget(self, action: #selector(finishQuiz), for: .touchUpInside)
        finishButton.backgroundColor = .white
        finishButton.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(finishButton)
        
        finishButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(100)
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
}

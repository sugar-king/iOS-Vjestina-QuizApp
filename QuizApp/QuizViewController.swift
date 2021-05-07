import Foundation
import UIKit

class QuizViewController : UIViewController {
    
    let router: AppRouterProtocol
    let quiz: Quiz
    
    var questionNumberLabel: UILabel!
    var questionPages: UIPageViewController!
    var results: [Bool] = []
    var bars: [UIView] = []
    
    init(router: AppRouterProtocol, quiz: Quiz) {
        self.router = router
        self.quiz = quiz
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        view.backgroundColor = .green
        let numberOfQuestion = quiz.questions.count
        print(numberOfQuestion)
        for i in 1...numberOfQuestion {
            let rect = UIView()
            rect.backgroundColor = .white
            rect.alpha = 0.5
            print(rect)
            bars.append(rect)
            view.addSubview(rect)
            if i == 1 {
                rect.alpha = 1
                rect.snp.makeConstraints {
                    $0.top.equalToSuperview().offset(100)
                    $0.height.equalTo(10)
                    $0.leading.equalToSuperview().offset(10)
                    $0.width.equalTo(50)
                }
            } else {
                rect.snp.makeConstraints {
                    $0.top.equalTo(bars[i-2].snp.top)
                    $0.height.equalTo(bars[i-2].snp.height)
                    $0.leading.equalTo(bars[i-2].snp.trailing).offset(10)
                    $0.width.equalTo(bars[i-2].snp.width)
                }
            }
    }
    
}
    override func viewDidAppear(_ animated: Bool) {
        print(bars[0])
    }

}

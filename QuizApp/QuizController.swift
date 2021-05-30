import Foundation
import UIKit


class QuizController : UIViewController {
    
    let router: AppRouterProtocol
    let quiz: QuizViewModel
    let startingTime = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
    
    var currentQuestion = 1
    
    var questionNumberLabel: UILabel!
    var progressTracker: QuestionTrackerView!
    var questionPages: UIPageViewController!
    var results = 0
    
    init(router: AppRouterProtocol, quiz: QuizViewModel) {
        self.router = router
        self.quiz = quiz
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        view.backgroundColor = .systemBlue
        
        buildViews()
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func buildViews() {
        questionNumberLabel = UILabel()
        view.addSubview(questionNumberLabel)
        
        questionNumberLabel.text = "\(currentQuestion)/\(quiz.questions.count)"
        questionNumberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalToSuperview().offset(10)
        }
        
        progressTracker = QuestionTrackerView(quiz.questions.count)
        view.addSubview(progressTracker)
        
        progressTracker.snp.makeConstraints {
            $0.top.equalTo(questionNumberLabel.snp.bottom).offset(10)
            $0.width.equalToSuperview().inset(20)
            $0.height.equalTo(15)
            $0.centerX.equalToSuperview()
        }
        questionPages = QuizPageController(quiz, answerQuestion)
        view.addSubview(questionPages.view)
        addChild(questionPages)
        questionPages.didMove(toParent: self)
        
        
        questionPages.view.snp.makeConstraints {
            $0.top.equalTo(progressTracker.snp.bottom).offset(5)
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
        
        
        
    }
    
    func answerQuestion(_ correct: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5,
                                      execute: { [self] in
                                        results += correct ? 1 : 0
                                        if currentQuestion == quiz.questions.count {
                                            router.showQuizResults(quizId: quiz.id, correct: results, of: quiz.questions.count, time: Date().timeIntervalSince(startingTime))
                                            return
                                        } else {
                                            currentQuestion += 1
                                            progressTracker.answerQuestion(correct)
                                        }
                                      })
        }
}



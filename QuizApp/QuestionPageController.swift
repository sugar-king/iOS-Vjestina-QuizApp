import Foundation
import UIKit

class QuizPageController : UIPageViewController {
    let quiz: QuizViewModel
    private var controllers: [QuestionController]
    private var displayedIndex = 0
    let updateProgress: (_ :Bool) -> ()
    
    init(_ quiz: QuizViewModel, _ update: @escaping (_ :Bool) -> ()) {
        self.quiz = quiz
        self.updateProgress = update
        controllers = [QuestionController]()
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
        
        for i in 0...quiz.questions.count-1 {
            let question = QuestionController(quiz.questions[i], answerQuestion(_:))
            controllers.append(question)
        }
        
        guard let firstVC = controllers.first else { return }
        
        setViewControllers([firstVC], direction: .forward, animated: true,
                           completion: nil)
    }
    
    func answerQuestion(_ correct: Bool) {
        displayedIndex += 1
        updateProgress(correct)
        if displayedIndex >= quiz.questions.count {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5,
                                      execute: { [self] in
                                        
                                        let firstVC = controllers[displayedIndex]
                                        
                                        setViewControllers([firstVC], direction: .forward, animated: true,
                                                           completion: nil)
                                      })
    }
}


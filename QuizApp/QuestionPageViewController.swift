import Foundation
import UIKit

class QuizPageViewController : UIPageViewController {
    let quiz: Quiz
    private var controllers: [QuestionViewController]
    private var displayedIndex = 0
    let updateProgress: (_ :Bool) -> ()
    
    init(_ quiz: Quiz, _ update: @escaping (_ :Bool) -> ()) {
        self.quiz = quiz
        self.updateProgress = update
        controllers = [QuestionViewController]()
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
        
        for i in 0...quiz.questions.count-1 {
            let question = QuestionViewController(quiz.questions[i], answerQuestion(_:))
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


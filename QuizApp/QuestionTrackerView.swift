import Foundation
import UIKit

class QuestionTrackerView : UIStackView {
    let numberOfQuestions: Int
    var currentQuestion: Int = 0
    
    init(_ numberOfQuestions: Int) {
        self.numberOfQuestions = numberOfQuestions
        super.init(frame: .zero)
        
        initSubviews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initSubviews() {
        for _ in 1...numberOfQuestions {
            let questionIndicator = UIView()
            questionIndicator.backgroundColor = .white
            questionIndicator.alpha = 0.6
            addArrangedSubview(questionIndicator)

            questionIndicator.snp.makeConstraints {
                $0.height.equalTo(10)
            }
            questionIndicator.layer.cornerRadius = 5
//            questionIndicator.addConstraint(NSLayoutConstraint(item: questionIndicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 10))
        }
        alignment = .center
        axis = .horizontal
        distribution = .fillEqually
        spacing = 15
        arrangedSubviews[0].alpha = 1
    }
    
    func answerQuestion(_ correctly: Bool) {
        arrangedSubviews[currentQuestion].backgroundColor = correctly ? .green : .red
        
        currentQuestion += 1
        
        arrangedSubviews[currentQuestion].alpha = 1
    }
}

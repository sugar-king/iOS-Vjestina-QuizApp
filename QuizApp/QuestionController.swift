import Foundation
import UIKit

class QuestionController : UIViewController {
    let question: Question!
    let answerQuestion: (_ correctly:Bool) -> ()
    
    var questionText: UILabel!
    var answersStackView: UIStackView!
    var active = true
    
    
    init(_ question: Question, _ answerQuestion: @escaping (_ correctly:Bool) -> ()) {
        self.question = question
        self.answerQuestion  = answerQuestion
        super.init(nibName: nil, bundle: nil)
        
        buildSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildSubviews() {
        questionText = UILabel()
        questionText.text = question.question
        questionText.numberOfLines = 0
        questionText.font = questionText.font.withSize(25)
        
        view.addSubview(questionText)
        
        questionText.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.lessThanOrEqualToSuperview().inset(10)
        }
        
        answersStackView = UIStackView()
        
        answersStackView.axis = .vertical
        answersStackView.alignment = .center
        answersStackView.distribution = .fillEqually
        answersStackView.spacing = 10
        view.addSubview(answersStackView)
        
        answersStackView.snp.makeConstraints {
            $0.top.equalTo(questionText.snp.bottom).offset(5)
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        for i in 0...3 {
            let button = UIButton()
            button.setTitle(question.answers[i], for: .normal)
            button.titleLabel?.font = button.titleLabel?.font.withSize(20)
            button.setTitleColor(.blue, for: .normal)
            button.tag = i
            
            answersStackView.addArrangedSubview(button)
            
            button.backgroundColor = .white
            button.addTarget(self, action: #selector(answer), for: .touchUpInside)
            button.snp.makeConstraints{
                $0.width.equalToSuperview().inset(50)
            }
            button.layer.cornerRadius = 50
            
        }
    }
    
    @objc
    func answer(_ sender: UIButton) {
        if !active {
            return
        }
        active = !active
        answersStackView.arrangedSubviews[question.correctAnswer].backgroundColor = .green
        if(sender.tag != question.correctAnswer) {
            answersStackView.arrangedSubviews[sender.tag].backgroundColor = .red
            answerQuestion(false)
        } else {
            answerQuestion(true)
        }
    }
}

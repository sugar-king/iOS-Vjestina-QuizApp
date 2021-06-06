import UIKit

struct QuizViewModel {

    let id: Int
    let title: String
    let description: String
    let category: String
    let level: String
    let image: UIImage?
    let questions: [Question]

    init(_ quiz: Quiz) {
        self.id = quiz.id
        self.title = quiz.title
        self.description = quiz.description
        self.category = quiz.category.rawValue
        self.level = String(quiz.level) + "/3"
        
        let imageUrl = URL(string: quiz.imageUrl)!
        let imageData = try? Data(contentsOf: imageUrl)
        self.image = UIImage(data: (imageData ?? UIImage(systemName: "questionmark")?.pngData())!)
        
        self.questions = quiz.questions
    }

}

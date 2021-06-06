import CoreData
import Foundation

extension Quiz {
    init(with entity: CDQuiz) {
        id = Int(entity.quizId)
        title = entity.title ?? ""
        description = entity.quizDescription ?? ""
        category = QuizCategory.init(rawValue: entity.category ?? "")!
        level = Int(entity.level)
        imageUrl = entity.imageUrl ?? ""
        var newQuestions = [Question]()
        let cdQuestions = entity.questions?.array as? [CDQuestion] ?? []
        for question in cdQuestions {
            newQuestions.append(Question(with: question))
        }
        questions = newQuestions
    }

    func populate(_ entity: CDQuiz, context: NSManagedObjectContext) {
        entity.quizId = Int32(id)
        entity.title = title
        entity.quizDescription = description
        entity.category = category.rawValue
        entity.level = Int16(level)
        entity.imageUrl = imageUrl
        entity.questions = NSOrderedSet()
        for question in questions {
            var cdQuestion = CDQuestion(context: context)
            question.populate(cdQuestion)
            entity.addToQuestions(cdQuestion)

        }
    }
}

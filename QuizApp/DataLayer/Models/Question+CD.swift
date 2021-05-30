import CoreData

extension Question {
    init(with entity: CDQuestion) {
        id = Int(entity.questionId)
        question = entity.question ?? ""
        answers = entity.answers ?? []
        correctAnswer = Int(entity.correctAnswer)
    }

    func populate(_ entity: CDQuestion) {
        entity.questionId = Int32(id)
        entity.question = question
        entity.answers = answers
        entity.correctAnswer = Int16(correctAnswer)
    }
}

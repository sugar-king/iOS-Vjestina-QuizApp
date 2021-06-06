final class QuizUseCase {

    private let quizRepository: QuizRepositoryProtocol


    init(quizRepository: QuizRepositoryProtocol) {
        self.quizRepository = quizRepository
    }

    func refreshData(onCompletion: @escaping () -> Void) throws {
        try quizRepository.fetchRemoteData(onCompletion: onCompletion)
    }

    func getQuizzes(filter: FilterSettings? = nil) -> [Quiz] {
        quizRepository.fetchLocalData(filter: filter)
    }
}

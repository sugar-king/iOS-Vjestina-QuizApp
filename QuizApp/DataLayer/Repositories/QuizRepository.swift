import Foundation

class QuizRepository : QuizRepositoryProtocol {
    private let networkDataSource: QuizNetworkDataSource
    private let coreDataSource: QuizDatabaseDataSource
    
    init(networkDataSource: QuizNetworkDataSource, coreDataSource: QuizDatabaseDataSource) {
        self.networkDataSource = networkDataSource
        self.coreDataSource = coreDataSource
    }
    
    func fetchRemoteData( onCompletion: @escaping () -> Void) throws {
        try networkDataSource.fetchQuizzes() { [weak self] quizzes, error in
            self?.coreDataSource.saveNewQuizzes(quizzes ?? [])
            onCompletion()
        }
    }
    
    func fetchLocalData(filter: FilterSettings?) -> [Quiz] {
        coreDataSource.fetchQuizzesFromCoreData(filter: filter)
    }
}

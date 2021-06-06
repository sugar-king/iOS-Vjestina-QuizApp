import Foundation

class QuizNetworkDataSource {
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchQuizzes(onCompletion: @escaping ([Quiz]?, RequestError?) -> Void) throws {
        try networkService.fetchQuizzes(onCompletion: onCompletion)
    }
}

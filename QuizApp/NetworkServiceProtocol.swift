import Foundation

protocol NetworkServiceProtocol {
    func login(email: String, password: String, onCompletion: @escaping (LoginStatus)->Void)

    func fetchQuizzes(onCompletion: @escaping ([Quiz]?, RequestError?) -> Void)
    
    func uploadQuizResults(quizResult: QuizResult)
    
    func fetchLeaderboard(quizId: Int, onCompletion: @escaping ([LeaderboardResult]?, RequestError?) -> Void)
}

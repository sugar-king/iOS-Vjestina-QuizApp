import Foundation

protocol QuizRepositoryProtocol {
    func fetchRemoteData(onCompletion: @escaping () -> Void) throws
    func fetchLocalData(filter: FilterSettings?) -> [Quiz]
}

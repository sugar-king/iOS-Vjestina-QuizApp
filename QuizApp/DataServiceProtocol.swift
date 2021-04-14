protocol DataServiceProtocol {

    func login(email: String, password: String) -> LoginStatus

    func fetchQuizes() -> [Quiz]

}

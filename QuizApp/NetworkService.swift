import Foundation
import Reachability


class NetworkService : NetworkServiceProtocol {
    let baseUrl = "https://iosquiz.herokuapp.com/api"
    
    func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler:
                                            @escaping (Result<T, RequestError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response,
                                                                   err in
            
            guard err == nil else {
                completionHandler(.failure(.clientError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.serverError))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.noDataError))
                return
            }
            guard let value = try? JSONDecoder().decode(T.self, from: data) else {
                completionHandler(.failure(.decodingError))
                return
            }
            completionHandler(.success(value))
        }
        dataTask.resume()
    }
    
    func login(email: String, password: String, onCompletion: @escaping (LoginStatus)->Void) {
        guard let reachability = Reachability.init(hostName: baseUrl),
              reachability.isReachable()
        else {
            onCompletion(.error(1, "No network"))
            return
        }
        
        guard var urlComp = URLComponents(string: "\(baseUrl)/session") else { return }
        
        urlComp.queryItems = [URLQueryItem(name: "username", value: email), URLQueryItem(name: "password", value: password)]
        
        guard let url = urlComp.url else { return }
        var request = URLRequest(url: url )
        request.httpMethod = "POST"
        
        executeUrlRequest(request) { (result: Result<LoginData, RequestError>) in
            switch result {
            case .failure(let error):
                onCompletion(.error(2, error.localizedDescription))
            case .success(let value):
                UserDefaults.standard.set(value.token, forKey: "token")
                UserDefaults.standard.set(value.userId, forKey: "user_id")
                onCompletion(.success)
            }
        }
    }
    
    
    func fetchQuizzes(onCompletion: @escaping ([Quiz]?, RequestError?) -> Void) {
        let reach = Reachability.init(hostName: baseUrl)
        if !(reach?.isReachable() ?? false) {
            onCompletion([], .clientError)
            return
        }
        
        guard let url = URL(string: "\(baseUrl)/quizzes") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        executeUrlRequest(request, completionHandler: { (result: Result<QuizzesResponse, RequestError>) in
            switch result {
            case .success(let value):
                    onCompletion(value.quizzes, nil)
            case .failure(_):
                return
            }
        })
    }
    
    func uploadQuizResults(quizResult: QuizResult) {
        let reach = Reachability.init(hostName: baseUrl)
        if !(reach?.isReachable() ?? false) {
            return
        }
        
        guard let url = URL(string: "\(baseUrl)/result") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(UserDefaults.standard.string(forKey: "token"), forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(quizResult)
        
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response,
                                                                   err in
            if let httpResponse = response as? HTTPURLResponse {
                let status = ServerResponse(rawValue: httpResponse.statusCode)
                print(status?.rawValue ?? "200")
            }
        }
        dataTask.resume()
    }
    
    func fetchLeaderboard(quizId: Int, onCompletion: @escaping ([LeaderboardResult]?, RequestError?) -> Void) {
        let reach = Reachability.init(hostName: baseUrl)
        if !(reach?.isReachable() ?? false) {
            onCompletion(nil, .clientError)
            return
        }
        
        guard var url = URLComponents(string: "\(baseUrl)/score") else {return}
        url.queryItems = [URLQueryItem(name: "quiz_id", value: String(quizId))]

        var request = URLRequest(url: url.url!)
        request.setValue(UserDefaults.standard.string(forKey: "token"), forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        executeUrlRequest(request, completionHandler: { (result: Result<[LeaderboardResult], RequestError>) in
            switch result {
            case .success(let value):
                onCompletion(value, nil)
    
            case .failure(_):
                onCompletion(nil, .serverError)
            }
        })
    }

}

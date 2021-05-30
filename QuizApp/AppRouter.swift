import Foundation
import UIKit

protocol AppRouterProtocol {
    func setStartScreen(in window: UIWindow?)
    func showHomeController()
    func returnToHomeController()
    func showQuizController(quiz: QuizViewModel)
    func showQuizResults(quizId: Int,correct: Int, of: Int, time: TimeInterval)
    func showLogin()
    func showLeaderborder(quizId: Int)
    func hideLeaderborder()
}
class AppRouter: AppRouterProtocol {
    
    private let quizUseCase: QuizUseCase
    private let navigationController: UINavigationController!
    
    init(navigationController: UINavigationController, quizUseCase: QuizUseCase) {
        self.navigationController = navigationController
        self.quizUseCase = quizUseCase
    }
    func setStartScreen(in window: UIWindow?) {
         let vc = LoginController(router: self)
//        let vc = QuizzesController(router: self, useCase: quizUseCase)
        navigationController.pushViewController(vc, animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func showHomeController() {
        let vc = HomeController(router: self, useCase: quizUseCase)
        navigationController.setViewControllers([vc], animated: true)
    }
    
    func showQuizController(quiz: QuizViewModel) {
        navigationController.navigationBar.isHidden = false
        navigationController.isNavigationBarHidden = false
        let vc = QuizController(router: self, quiz: quiz)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showQuizResults(quizId: Int, correct: Int, of: Int, time: TimeInterval) {
        let resultsVC = QuizResultsController(router: self, quizId: quizId, correct: correct,  of: of, time: time)
        navigationController.pushViewController(resultsVC, animated: true)
    }
    func returnToHomeController() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func showLogin() {
        let login = LoginController(router: self)
        navigationController.setViewControllers([login], animated: true)
    }
    
    func showLeaderborder(quizId: Int) {
        let board = LeaderboardController(router: self, quizId: quizId)
        board.modalPresentationStyle = .fullScreen
        navigationController.present(board, animated: true, completion: nil)
    }
    
    func hideLeaderborder() {
        navigationController.dismiss(animated: true, completion: nil)
    }

}

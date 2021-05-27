import Foundation
import UIKit

protocol AppRouterProtocol {
    func setStartScreen(in window: UIWindow?)
    func showHomeController()
    func returnToHomeController()
    func showQuizController(quiz: Quiz)
    func showQuizResults(quizId: Int,correct: Int, of: Int, time: TimeInterval)
    func showLogin()
    func showLeaderborder(quizId: Int)
    func hideLeaderborder()
}
class AppRouter: AppRouterProtocol {
    
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func setStartScreen(in window: UIWindow?) {
        let vc = LoginViewController(router: self)
        navigationController.pushViewController(vc, animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func showHomeController() {
        let vc = HomeViewController(router: self)
        navigationController.setViewControllers([vc], animated: true)
    }
    
    func showQuizController(quiz: Quiz) {
        navigationController.navigationBar.isHidden = false
        navigationController.isNavigationBarHidden = false
        let vc = QuizViewController(router: self, quiz: quiz)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showQuizResults(quizId: Int, correct: Int, of: Int, time: TimeInterval) {
        let resultsVC = QuizResultsViewController(router: self, quizId: quizId, correct: correct,  of: of, time: time)
        navigationController.pushViewController(resultsVC, animated: true)
    }
    func returnToHomeController() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func showLogin() {
        let login = LoginViewController(router: self)
        navigationController.setViewControllers([login], animated: true)
    }
    
    func showLeaderborder(quizId: Int) {
        let board = LeaderboardViewController(router: self, quizId: quizId)
        board.modalPresentationStyle = .fullScreen
        navigationController.present(board, animated: true, completion: nil)
    }
    
    func hideLeaderborder() {
        navigationController.dismiss(animated: true, completion: nil)
    }

}

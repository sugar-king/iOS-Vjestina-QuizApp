import Foundation
import UIKit

protocol AppRouterProtocol {
    func setStartScreen(in window: UIWindow?)
    func showHomeController()
    func returnToHomeController()
    func showQuizController(quiz: Quiz)
    func showQuizResults(correct: Int, of: Int)
    func showLogin()
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
    
    func showQuizResults(correct: Int, of: Int) {
        let resultsVC = QuizResultsViewController(correct: correct, of: of, router: self)
        navigationController.pushViewController(resultsVC, animated: true)
    }
    func returnToHomeController() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func showLogin() {
        let login = LoginViewController(router: self)
        navigationController.setViewControllers([login], animated: true)
    }
}

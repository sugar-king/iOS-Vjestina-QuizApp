import Foundation
import UIKit

protocol AppRouterProtocol {
    func setStartScreen(in window: UIWindow?)
    func showQuizzesController()
    func showQuizController(quiz: Quiz)
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
    
    func showQuizzesController() {
        let vc = QuizzesViewController(router: self)
        navigationController.setViewControllers([vc], animated: true)
    }
    
    func showQuizController(quiz: Quiz) {
        navigationController.isNavigationBarHidden = false
        let vc = QuizViewController(router: self, quiz: quiz)
        navigationController.pushViewController(vc, animated: true)
    }
}

import Foundation
import UIKit

class HomeController : UITabBarController {
    let router: AppRouterProtocol
    let useCase: QuizUseCase
    var quizzes: QuizzesController!
    var search: SearchQuizViewController!
    var settings: SettingsController!
    
    init(router: AppRouterProtocol, useCase: QuizUseCase) {
        self.router = router
        self.useCase = useCase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        quizzes = QuizzesController(router: router, useCase: useCase)
        search = SearchQuizViewController(router: router, useCase: useCase)
        settings = SettingsController(router: router)
        
        quizzes.tabBarItem = UITabBarItem(title: "Quiz", image: UIImage(systemName: "stopwatch"), selectedImage: UIImage(systemName: "stopwatch.fill"))
        
        search.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass.circle"), selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
        
        settings.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        
        viewControllers = [quizzes, search, settings]
        selectedIndex = 1
    }
}

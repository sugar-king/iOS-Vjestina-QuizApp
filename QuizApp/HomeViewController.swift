import Foundation
import UIKit

class HomeViewController : UITabBarController {
    let router: AppRouterProtocol
    
    var quizzes: QuizzesViewController!
    var settings: SettingsViewController!
    
    init(router: AppRouterProtocol) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        quizzes = QuizzesViewController(router: router)
        settings = SettingsViewController(router: router)
        
        quizzes.tabBarItem = UITabBarItem(title: "Quiz", image: UIImage(systemName: "stopwatch"), selectedImage: UIImage(systemName: "stopwatch.fill"))
        
        settings.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        
        viewControllers = [quizzes, settings]
    }
}

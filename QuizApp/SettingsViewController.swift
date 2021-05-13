import Foundation
import UIKit

class SettingsViewController : UIViewController {
    var unLabel: UILabel!
    var usernameLabel: UILabel!
    var logOutBtn: UIButton!
    
    let router: AppRouterProtocol
    
    init(router: AppRouterProtocol) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBlue
        
        unLabel = UILabel()
        unLabel.text = "USERNAME"
        unLabel.textColor = .white
        view.addSubview(unLabel)
        
        unLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(20)
        }
        
        usernameLabel = UILabel()
        usernameLabel.text = "Igor Aradski"
        usernameLabel.textColor = .white
        usernameLabel.font = usernameLabel.font.withSize(25)
        view.addSubview(usernameLabel)
        
        usernameLabel.snp.makeConstraints {
            $0.top.equalTo(unLabel.snp.bottom).offset(5)
            $0.leading.equalTo(unLabel.snp.leading)
        }
        
        logOutBtn = UIButton()
        logOutBtn.setTitle("Log out", for: .normal)
        logOutBtn.backgroundColor = .white
        logOutBtn.setTitleColor(.systemBlue, for: .normal)
        logOutBtn.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        view.addSubview(logOutBtn)
        
        logOutBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(100)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc
    func logOut() {
        router.showLogin()
    }
}

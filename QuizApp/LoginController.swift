import UIKit
import SnapKit

class LoginController: UIViewController {
    
    var titleLabel: UILabel!
    var stackView: UIStackView!
    var emailField: UITextField!
    var passwordField: UITextField!
    var loginButton: UIButton!
    let backgroundColor = UIColor.systemBlue
    let textColor = UIColor.white
    let router: AppRouterProtocol
    
    var dataService: NetworkServiceProtocol!
    
    init(router: AppRouterProtocol) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildView()
        defineLayoutForViews()
        styleView()
        
        dataService = NetworkService()
    }
    
    private func buildView(){
        navigationItem.title = "Login"
        
        titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.text = "QuizApp"
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        emailField = UITextField()
        emailField.placeholder = "Email"
        emailField.delegate = self
        emailField.returnKeyType = .next
        emailField.keyboardType = UIKeyboardType.emailAddress
        emailField.setLeftPaddingPoints(10)
        stackView.addArrangedSubview(emailField)
        
        
        passwordField = UITextField()
        passwordField.placeholder = "Password"
        passwordField.delegate = self
        passwordField.returnKeyType = .done
        passwordField.isSecureTextEntry = true
        passwordField.setLeftPaddingPoints(10)
        stackView.addArrangedSubview(passwordField)
        
        loginButton = UIButton()
        stackView.addArrangedSubview(loginButton)
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        
    }
    
    @objc private func login() {
        loginButton.isEnabled = false
        dataService.login(email: emailField.text!, password: passwordField.text!) {
            [weak self] response in
            guard let self = self else { return }
            switch response{
            case .success:
                DispatchQueue.main.async {
                    self.router.showHomeController()
                }
            case .error(let code, _):
                if code == 1 {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "No network connection.", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.loginButton.isEnabled = true

                    }
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Login failed.", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.loginButton.isEnabled = true
                    }
                }
            }
        }
    }
    
    private func styleView(){
        navigationController?.navigationBar.barTintColor = backgroundColor
        
        view.backgroundColor = backgroundColor
        
        titleLabel.textColor = textColor
        titleLabel.font = titleLabel.font.withSize(70)
        
        emailField.backgroundColor = .white
        
        passwordField.backgroundColor = .white
        
        loginButton.backgroundColor = .white
        loginButton.setTitleColor(backgroundColor, for: .normal)
        loginButton.clipsToBounds = true
        
    }
    
    private func defineLayoutForViews() {
        emailField.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        passwordField.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        loginButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        emailField.layer.cornerRadius = 20
        passwordField.layer.cornerRadius = 20
        loginButton.layer.cornerRadius = 20
        
        stackView.spacing = 20
        stackView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(titleLabel.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.centerY.greaterThanOrEqualToSuperview()
            $0.leading.trailing.equalToSuperview().inset(50)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
            
        }
    }
}

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func switchBasedNextTextField(_ textField: UITextField) {
        self.passwordField.becomeFirstResponder()
    }
    
}

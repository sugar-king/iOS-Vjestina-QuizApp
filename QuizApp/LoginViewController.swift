//
//  LoginViewController.swift
//  QuizApp
//
//  Created by five on 13.04.2021..
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    var titleLabel: UILabel!
    var loginButton: UIButton!
    var emailField: UITextField!
    var passwordField: UITextField!
    var stackView: UIStackView!
    
    var dataService: DataService!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildView()
        defineLayoutForViews()
        styleView()
        
        dataService = DataService()
    }
    
    
    private func buildView(){
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
        stackView.addArrangedSubview(emailField)
        
        
        passwordField = UITextField()
        passwordField.placeholder = "Password"
        passwordField.delegate = self
        passwordField.returnKeyType = .done
        passwordField.isSecureTextEntry = true
        stackView.addArrangedSubview(passwordField)
        
        loginButton = UIButton()
        stackView.addArrangedSubview(loginButton)
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        
    }
    
    @objc private func login() {
        let response = self.dataService.login(email: self.emailField.text!, password: self.passwordField.text!)
        switch response{
        case .success:
            print("Email: " + self.emailField.text! + ", password: " +  self.passwordField.text!)
            break
        default:
            print(response)
        }
    }
    
    private func styleView(){
        view.backgroundColor = .systemBlue
        
        titleLabel.textColor = .white
        titleLabel.font = titleLabel.font.withSize(70)
        
        emailField.backgroundColor = .white
        
        passwordField.backgroundColor = .white
        
        loginButton.backgroundColor = .white
        loginButton.setTitleColor(.systemBlue, for: .normal)
        loginButton.clipsToBounds = true
        
    }
    
    private func defineLayoutForViews() {
        emailField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func switchBasedNextTextField(_ textField: UITextField) {
        self.passwordField.becomeFirstResponder()
    }
    
}

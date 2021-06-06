import UIKit

extension LoginController {
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.transform = titleLabel.transform.scaledBy(x: 0, y: 0)
        titleLabel.alpha = 0
        
        emailField.transform = emailField.transform.translatedBy(x: -view.frame.width, y: 0)
        emailField.alpha = 0
        
        passwordField.transform = passwordField.transform.translatedBy(x: -view.frame.width, y: 0)
        passwordField.alpha = 0
        
        loginButton.transform = loginButton.transform.translatedBy(x: -view.frame.width, y: 0)
        loginButton.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(
            withDuration: 1.5,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.titleLabel.transform = .identity
                self.titleLabel.alpha = 1
            })
        UIView.animate(
            withDuration: 1.5,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.emailField.transform = .identity
                self.emailField.alpha = 1
            })
        UIView.animate(
            withDuration: 1.5,
            delay: 0.25,
            options: .curveEaseInOut,
            animations: {
                self.passwordField.transform = .identity
                self.passwordField.alpha = 1
            })
        UIView.animate(
            withDuration: 1.5,
            delay: 0.50,
            options: .curveEaseInOut,
            animations: {
                self.loginButton.transform = .identity
                self.loginButton.alpha = 1
            })
    }
    
    func finishLogin(){
        UIView.animate(
            withDuration: 1.5,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.titleLabel.transform = self.titleLabel.transform.translatedBy(x: 0, y: -self.view.frame.height)
            })
        UIView.animate(
            withDuration: 1.5,
            delay: 0.25,
            options: .curveEaseInOut,
            animations: {
                self.emailField.transform = self.emailField.transform.translatedBy(x: 0, y: -self.view.frame.height)
            })
        UIView.animate(
            withDuration: 1.5,
            delay: 0.50,
            options: .curveEaseInOut,
            animations: {
                self.passwordField.transform = self.passwordField.transform.translatedBy(x: 0, y: -self.view.frame.height)
            })
        UIView.animate(
            withDuration: 1.5,
            delay: 0.75,
            options: .curveEaseInOut,
            animations: {
                self.loginButton.transform = self.loginButton.transform.translatedBy(x: 0, y: -self.view.frame.height)
            }, completion: {_ in
                self.router.showHomeController()
            })
        
    }
}

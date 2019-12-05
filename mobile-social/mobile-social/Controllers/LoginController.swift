//
//  LoginController.swift
//  mobile-social
//
//  Created by Yi Zheng on 2019-11-20.
//  Copyright © 2019 Yi Zheng. All rights reserved.
//

import LBTATools
import Alamofire
import JGProgressHUD

class LoginController: LBTAFormController {
    
//    let logoImageView = UIImageView(image: <#T##UIImage?#>, contentMode: <#T##UIView.ContentMode#>)
    let emailTextField = IndentedTextField(placeholder: "Email", padding: 24, cornerRadius: 25, keyboardType: .emailAddress, backgroundColor: .white, isSecureTextEntry: false)
    let passwordTextField = IndentedTextField(placeholder: "Password", padding: 24, cornerRadius: 25, keyboardType: .default, backgroundColor: .white, isSecureTextEntry: true)
    lazy var loginButton = UIButton(title: "Login", titleColor: .white, font: .boldSystemFont(ofSize: 18), backgroundColor: .black, target: self, action: #selector(handleLogin))
    let errorLable = UILabel(text: "Your login credentials were incorrect, please try again", font: .systemFont(ofSize: 14), textColor: .red, textAlignment: .center, numberOfLines: 0)
    lazy var goToRegisterButton = UIButton(title: "Need an account? Go to  register.", titleColor: .black, font: .systemFont(ofSize: 16), target: self, action: #selector(goToRegister))
    
    @objc fileprivate func goToRegister() {
//        ------in first page-----
        let registerController = RegisterController()
        navigationController?.pushViewController(registerController, animated: true)
//        ------go back in second page----
//        navigationController?.popViewController(animated: true)

    
    }
    
    @objc fileprivate func handleLogin() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Logging in"
        hud.show(in: view)
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        errorLable.isHidden = true
        
        let url = "http://localhost:1337/api/v1/entrance/login"
        let params = ["emailAddress": email, "password": password]
        Alamofire.request(url, method: .put, parameters: params, encoding: URLEncoding()).responseData { (dataResponse) in
            hud.dismiss()
            print("Finally sent request to server..")
            self.dismiss(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(white: 0.95, alpha: 1)
        
        navigationController?.navigationBar.isHidden = true
        errorLable.isHidden = true
        
        let formView = UIView()
        formView.stack(
            emailTextField.withHeight(50),
            passwordTextField.withHeight(50),
            loginButton.withHeight(50),
            errorLable,
            goToRegisterButton,
            spacing:16
        ).withMargins(.init(top: 48, left: 32, bottom: 0, right: 32))
        
        formContainerStackView.padBottom(-24)
        formContainerStackView.addArrangedSubview(formView)
    }
}

//
//  RegisterController.swift
//  mobile-social
//
//  Created by Yi Zheng on 2019-11-20.
//  Copyright © 2019 Yi Zheng. All rights reserved.
//

import LBTATools
import Alamofire
import JGProgressHUD

class RegisterController: LBTAFormController {
    
    //MARK: UI Elements
    //indentedTextField is from LBTATools
    let fullNameTextField = IndentedTextField(placeholder: "Full Name", padding: 24, cornerRadius: 25, keyboardType: .default, backgroundColor: .white, isSecureTextEntry: false)
    let emailTextField = IndentedTextField(placeholder: "Email", padding: 24, cornerRadius: 25, keyboardType: .emailAddress, backgroundColor: .white, isSecureTextEntry: false)
    let passwordTextField = IndentedTextField(placeholder: "Password", padding: 24, cornerRadius: 25, keyboardType: .default, backgroundColor: .white, isSecureTextEntry: true)
    lazy var signUpButton = UIButton(title: "Sign Up", titleColor: .white, font: .boldSystemFont(ofSize: 18), backgroundColor: .black, target: self, action: #selector(handleSignup))
    
    let errorLabel = UILabel(text: "Something went wrong during sign up, please try again later", font: .systemFont(ofSize: 14), textColor: .red, textAlignment: .center, numberOfLines: 0)
    lazy var goBackButton = UIButton(title: "Go back to login", titleColor: .black, font: .systemFont(ofSize: 16), backgroundColor: .white, target: self, action: #selector(goToRegister))
    
    @objc fileprivate func goToRegister(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func handleSignup() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registering"
        hud.show(in: view)
        
        guard let fullName = fullNameTextField.text else {return}
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        let url = "http://localhost:1337/api/v1/entrance/signup"
        let params = ["fullName": fullName, "emailAddress": email, "password": password]
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseData { (dataResponse) in
                hud.dismiss()
                if let err = dataResponse.error {
                    self.errorLabel.isHidden = false
                    print("Failed to sign up:", err)
                    return
                }
                print("Successfully signed up")
                self.dismiss(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
        emailTextField.autocapitalizationType = .none
        [fullNameTextField, emailTextField, passwordTextField].forEach{$0.backgroundColor = .white}
        signUpButton.layer.cornerRadius = 25
        
        let formView = UIView()
        formView.stack(
            UIView().withHeight(12),
            fullNameTextField.withHeight(50),
            emailTextField.withHeight(50),
            passwordTextField.withHeight(50),
            errorLabel,
            signUpButton.withHeight(50),
            goBackButton,
            UIView().withHeight(80),
            spacing: 16).withMargins(.init(top: 48, left: 32, bottom: 0, right: 32))
        
        formContainerStackView.addArrangedSubview(formView)
    }
}

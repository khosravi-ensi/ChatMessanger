//
//  LoginController.swift
//  gameOfChat
//
//  Created by Ensi Khosravi on 8/20/21.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    private lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Icon1")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    private lazy var inputsContainerView: UIView = {
        let container = UIView()
        container.backgroundColor = .white
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 5
        container.layer.masksToBounds = true
        return container
    }()
    
    private lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            //successfully authenticated user
        }
    }
    
    private lazy var nameTextField: UITextField = {
        let name = UITextField()
        name.placeholder = "Name"
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private lazy var nameSepratorView: UIView = {
        let seprator = UIView()
        seprator.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        seprator.translatesAutoresizingMaskIntoConstraints = false
        return seprator
    }()
    
    private lazy var emailTextField: UITextField = {
        let email = UITextField()
        email.placeholder = "Email"
        email.translatesAutoresizingMaskIntoConstraints = false
        return email
    }()
    
    private lazy var emailSepratorView: UIView = {
        let seprator = UIView()
        seprator.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        seprator.translatesAutoresizingMaskIntoConstraints = false
        return seprator
    }()
    
    private lazy var passwordTextField: UITextField = {
        let password = UITextField()
        password.placeholder = "Password"
        password.translatesAutoresizingMaskIntoConstraints = false
        password.isSecureTextEntry = true
        return password
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        bindViews()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func bindViews() {
        bindContainerView()
        bindLoginRegisterButton()
        bindNameTextField()
        bindNameSepratorLineView()
        bindEmailTextField()
        bindEmailSepratorLineView()
        bindPasswordTextField()
        bindProfileImageView()
    }
    
    private func bindContainerView() {
        view.addSubview(inputsContainerView)
        NSLayoutConstraint.activate([
            inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24),
            inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
            
        ])
    }
    
    private func bindLoginRegisterButton() {
        view.addSubview(loginRegisterButton)
        NSLayoutConstraint.activate([
            loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12),
            loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            loginRegisterButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    
    private func bindNameTextField() {
        inputsContainerView.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12),
            nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor),
            nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
            
        ])
    }
    
    private func bindNameSepratorLineView() {
        inputsContainerView.addSubview(nameSepratorView)
        NSLayoutConstraint.activate([
            nameSepratorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor),
            nameSepratorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            nameSepratorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            nameSepratorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func bindEmailTextField() {
        inputsContainerView.addSubview(emailTextField)
        NSLayoutConstraint.activate([
            emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12),
            emailTextField.topAnchor.constraint(equalTo: nameSepratorView.bottomAnchor),
            emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        ])
    }
    
    private func bindEmailSepratorLineView() {
        inputsContainerView.addSubview(emailSepratorView)
        NSLayoutConstraint.activate([
            emailSepratorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor),
            emailSepratorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailSepratorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            emailSepratorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func bindPasswordTextField() {
        inputsContainerView.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12),
            passwordTextField.topAnchor.constraint(equalTo: emailSepratorView.bottomAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        ])
    }
    
    private func  bindProfileImageView() {
        view.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -40),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

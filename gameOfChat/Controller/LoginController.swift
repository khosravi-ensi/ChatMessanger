//
//  LoginController.swift
//  gameOfChat
//
//  Created by Ensi Khosravi on 8/20/21.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        sv.backgroundColor = .clear
        sv.bounces = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var inputsContainerView: UIView = {
        let container = UIView()
        container.backgroundColor = .white
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 5
        container.layer.masksToBounds = true
        return container
    }()
    
    private lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Icon1")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        
        return button
    }()
    @objc private func nextButtonAction() {
        loginRegisterSegmentedController.selectedSegmentIndex == 0 ? handleRegister() : handleLogin()
    }
    
    private func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        let validationFiels = [("email", email.isEmpty), ("password", password.isEmpty)]
        
        let unvalidFields = validationFiels.filter({ $0.1 == true })
        let string = unvalidFields.map({ $0.0 }).joined(separator: ", ")
        
        if unvalidFields.count > 0 {
            let alret = UIAlertController(title: "Alert", message: "Please fill the \(string) field", preferredStyle: .alert)
            alret.addAction(UIAlertAction(title: "ok", style: .destructive, handler: nil))
            self.present(alret, animated: true, completion: nil)
            
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard  error == nil else {
                let alret = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: .alert)
                alret.addAction(UIAlertAction(title: "ok", style: .destructive, handler: nil))
                self?.present(alret, animated: true, completion: nil)
                return
            }
            //successfully Loging user
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func handleRegister() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            return
        }
        
        let validationFiels = [("email", email.isEmpty), ("password", password.isEmpty), ("name", name.isEmpty)]
        
        let unvalidFields = validationFiels.filter({ $0.1 == true })
        let string = unvalidFields.map({ $0.0 }).joined(separator: ", ")
        
        if unvalidFields.count > 0 {
            let alret = UIAlertController(title: "Alert", message: "Please fill the \(string) field", preferredStyle: .alert)
            alret.addAction(UIAlertAction(title: "ok", style: .destructive, handler: nil))
            self.present(alret, animated: true, completion: nil)
            
            return
        }
        
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            guard  error == nil else {
                let alret = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: .alert)
                alret.addAction(UIAlertAction(title: "ok", style: .destructive, handler: nil))
                self?.present(alret, animated: true, completion: nil)
                return
            }
            //successfully creating user
            guard let result = result else {
                return
            }
            let ref = Database.database().reference(fromURL: "https://gameofchat-d4daa-default-rtdb.firebaseio.com/")
            
            let userRef = ref.child("users").child(result.user.uid)
            
            let values = [
                "name": name,
                "email": email
            ]
            
            userRef.updateChildValues(values) { [weak self] (error, ref) in
                guard let self = self else {
                    return
                }
                guard error == nil else {
                    let alret = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: .alert)
                    alret.addAction(UIAlertAction(title: "ok", style: .destructive, handler: nil))
                    self.present(alret, animated: true, completion: nil)
                    return
                }
                //successfully save data
                self.dismiss(animated: true, completion: nil)
            }
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
    
    private lazy var loginRegisterSegmentedController: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Register", "Login"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = UIColor(r: 61, g: 91, b: 160)
        sc.selectedSegmentTintColor = .white
        sc.selectedSegmentIndex = 0
        sc.layer.borderWidth = 1
        sc.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], for: .selected)
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    @objc private func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedController.titleForSegment(at: loginRegisterSegmentedController.selectedSegmentIndex)
        nextButton.setTitle(title, for: .normal)
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedController.selectedSegmentIndex == 1 ? 100 : 150
        nameTextFieldHeighConstraint?.constant = loginRegisterSegmentedController.selectedSegmentIndex == 1 ? 0 : 48
        nameSepratorView.backgroundColor = loginRegisterSegmentedController.selectedSegmentIndex == 1 ? .clear : UIColor(r: 220, g: 220, b: 220)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        bindViews()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func bindViews() {
        bindScrollView()
        bindMainView()
        bindContainerView()
        bindLoginRegisterButton()
        bindNameTextField()
        bindNameSepratorLineView()
        bindEmailTextField()
        bindEmailSepratorLineView()
        bindPasswordTextField()
        setupLoginRegisterSegmentedController()
        bindProfileImageView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func bindScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindMainView() {
        scrollView.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            mainView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupLoginRegisterSegmentedController() {
        mainView.addSubview(loginRegisterSegmentedController)
        NSLayoutConstraint.activate([
            loginRegisterSegmentedController.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginRegisterSegmentedController.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12),
            loginRegisterSegmentedController.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            loginRegisterSegmentedController.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    private func bindContainerView() {
        mainView.addSubview(inputsContainerView)
        NSLayoutConstraint.activate([
            inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24),
        ])
        inputsContainerViewHeightAnchor =  inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
    }
    
    private func bindLoginRegisterButton() {
        mainView.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12),
            nextButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    var nameTextFieldHeighConstraint: NSLayoutConstraint?
    private func bindNameTextField() {
        inputsContainerView.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12),
            nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor),
            nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor)
        ])
        nameTextFieldHeighConstraint = nameTextField.heightAnchor.constraint(equalToConstant: 48)
        nameTextFieldHeighConstraint?.isActive = true
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
            emailTextField.heightAnchor.constraint(equalToConstant: 48)
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
            passwordTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func  bindProfileImageView() {
        mainView.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedController.topAnchor, constant: -12),
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

//
//  MainViewController.swift
//  gameOfChat
//
//  Created by Ensi Khosravi on 8/20/21.
//

import UIKit
import  Firebase

class MainViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let ref = Database.database().reference(fromURL: "https://gameofchat-d4daa-default-rtdb.firebaseio.com/")
//        ref.updateChildValues(["someValue": 123123])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    
    @objc func handleLogout() {
//        try? Auth.auth().signOut()
        
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
        let loginController = LoginController()
        // For full screen presentation uncomment line bellow 
        loginController.modalPresentationStyle = .fullScreen
        present(loginController, animated: true, completion: nil)
        
    }
    
}


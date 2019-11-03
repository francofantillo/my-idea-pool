//
//  AuthenticationViewController.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-30.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {

    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    //MARK: - Utility
    
    private func getStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard
    }
    
    //MARK: - Login Functions
    
    func presentLoginView(){
        let storyboard = getStoryboard()
        let controller = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LogInViewController
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    func loginToApp(authenticationData: AuthenticationTokens){
        let storyboard = getStoryboard()
        DispatchQueue.main.async() {
            let controller = storyboard.instantiateViewController(withIdentifier: "IdeaViewController") as! IdeaViewController
            controller.authenticationTokens = authenticationData
            if let navigationController = self.navigationController {
                navigationController.pushViewController(controller, animated: true)
            }
        }
    }
    
    //MARK: - SignUp Functions
    
    func presentSignUpView(){
        
        let storyboard = getStoryboard()
        let controller = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    func signInToApp(authenticationData: AuthenticationTokens, insertIndex: Int){
        let storyboard = getStoryboard()
        DispatchQueue.main.async() {
            let controller = storyboard.instantiateViewController(withIdentifier: "IdeaViewController") as! IdeaViewController
            controller.authenticationTokens = authenticationData
            if let navigationController = self.navigationController {
                navigationController.pushViewController(controller, animated: true)
                navigationController.viewControllers.remove(at: 0)
                let insertIndex = navigationController.viewControllers.count - insertIndex
                let loginController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LogInViewController
                navigationController.viewControllers.insert(loginController, at: insertIndex)
            }
        }
    }
}

//MARK: - Textfield Delegate

extension AuthenticationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
            return true
    }
}

//MARK: - SignUpDelegate

extension AuthenticationViewController: SignUpDelegate {
    func SignUpDelegateFunc(tokenData: AuthenticationTokens) {
        signInToApp(authenticationData: tokenData, insertIndex: 0)
    }
}

//MARK: LogInDelegate

extension AuthenticationViewController: LogInDelegate {
    func LogInDelegateFunc(tokenData: AuthenticationTokens) {
        loginToApp(authenticationData: tokenData)
    }

}
 

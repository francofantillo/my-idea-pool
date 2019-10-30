//
//  AuthenticationViewController.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-30.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    private func getStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard
    }
    
    func loginToApp(){
        let storyboard = getStoryboard()
        let controller = storyboard.instantiateViewController(withIdentifier: "IdeaViewController") as! IdeaViewController
        if let navigationController = navigationController {
            navigationController.pushViewController(controller, animated: true)
        }
    }
    
    func presentSignUpView(){
        let storyboard = getStoryboard()
        let controller = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    func signInToApp(insertIndex: Int){
        let storyboard = getStoryboard()
        let controller = storyboard.instantiateViewController(withIdentifier: "IdeaViewController") as! IdeaViewController
        if let navigationController = navigationController {
            navigationController.pushViewController(controller, animated: true)
            navigationController.viewControllers.remove(at: 0)
            let insertIndex = navigationController.viewControllers.count - insertIndex
            let loginController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LogInViewController
            navigationController.viewControllers.insert(loginController, at: insertIndex)
        }
    }
    
    func presentLoginView(){
        let storyboard = getStoryboard()
        let controller = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LogInViewController
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
}

extension AuthenticationViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789-").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
            return true
    }
}

extension AuthenticationViewController: SignUpDelegate {
    
    func SignUpDelegateFunc() {
        signInToApp(insertIndex: 0)
    }
}

extension AuthenticationViewController: LogInDelegate {
    
    func LogInDelegateFunc() {
        loginToApp()
    }
}

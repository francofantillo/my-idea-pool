//
//  SignUpViewController.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-29.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import UIKit

class SignUpViewController: AuthenticationViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInOptionStackView: UIStackView!
    
    var delegate: LogInDelegate!
    var wasPresented = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardListeners()
        assignDelegates()
        configureKeyboard()
        wasPresented = self.isBeingPresented
        if self.wasPresented == true { logInOptionStackView.isHidden = true }
    }
    
    private func assignDelegates(){
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func configureKeyboard(){
        nameTextField.returnKeyType = UIReturnKeyType.done
        emailTextField.returnKeyType = UIReturnKeyType.done
        passwordTextField.returnKeyType = UIReturnKeyType.done
    }
    
    private func addKeyboardListeners(){
        //Notifications for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(adjustScrollView), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustScrollView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func adjustScrollView(notification: Notification){
        scrollView.adjustScrollViewForKeyboard(notification: notification, scrollView: self.scrollView, view: view.window!)
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        
        if self.wasPresented == true {
            self.dismiss(animated: true, completion: nil)
            delegate.LogInDelegateFunc()
        } else {
            signInToApp(insertIndex: 1)
        }
    }
    
    @IBAction func logInPressed(_ sender: Any) {
        presentLoginView()
    }
}

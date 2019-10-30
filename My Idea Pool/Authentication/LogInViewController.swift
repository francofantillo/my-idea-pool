//
//  LogInViewController.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-29.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import UIKit

class LogInViewController: AuthenticationViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpOptionStackView: UIStackView!
    
    var delegate: SignUpDelegate!
    var wasPresented = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardListeners()
        assignDelegates()
        configureKeyboard()
        self.wasPresented = self.isBeingPresented
        if self.wasPresented == true { signUpOptionStackView.isHidden = true }
    }
    
    private func assignDelegates(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func configureKeyboard(){
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
    
    @IBAction func loginPressed(_ sender: Any) {
        
        if self.wasPresented == true {
            self.dismiss(animated: true, completion: nil)
            delegate.SignUpDelegateFunc()
        } else {
            loginToApp()
        }
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        presentSignUpView()
    }
}


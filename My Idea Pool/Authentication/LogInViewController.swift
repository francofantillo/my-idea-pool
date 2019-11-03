//
//  LogInViewController.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-29.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import UIKit

class LogInViewController: AuthenticationViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpOptionStackView: UIStackView!
    
    //MARK: - Class Varibles
    
    var delegate: SignUpDelegate!
    var wasPresented = false
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardListeners()
        assignDelegates()
        configureKeyboard()
        self.wasPresented = self.isBeingPresented
        if self.wasPresented == true { signUpOptionStackView.isHidden = true }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Text and Keyboard Setup
    
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
    
    //MARK: IBActions
    
    @IBAction func createAccountPressed(_ sender: Any) {
        presentSignUpView()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        let email = emailTextField.text!
        guard email != "" else {
            PostAlerts.presentAlertController(viewController: self, titleMsg: "Email Error", errorMsg: "Please enter a name.")
            return
        }
        let password = passwordTextField.text!
        guard password != "" else {
            PostAlerts.presentAlertController(viewController: self, titleMsg: "Password Error", errorMsg: "Please enter a name.")
            return
        }
        
        let encodedUser = encodeUser(name: nil, email: email, password: password)
        
        RESTApiManager.sharedInstance.makeAPICall(endPoint: Endpoints.logInOut.rawValue, json: encodedUser, requestType: "POST", authToken: nil, completion: handleLoginResponse(data:error:))
    }
    
    //MARK: API Response
    
    private func handleLoginResponse(data: Data?, error: String?) {
        
        guard data != nil, error == nil else {
            DispatchQueue.main.async() { PostAlerts.presentAlertController(viewController: self, titleMsg: "Error", errorMsg: error!) }
            return
        }
        var authTokens: AuthenticationTokens!
        do { authTokens = try JSONDecoder().decode(AuthenticationTokens.self, from: data!) }
        catch {
            PostAlerts.presentAlertController(viewController: self, titleMsg: "Error", errorMsg: error.localizedDescription)
        }
        
        if self.wasPresented == true {
            DispatchQueue.main.async() { self.dismiss(animated: true, completion: nil) }
            delegate.SignUpDelegateFunc(tokenData: authTokens)
        } else {
            loginToApp(authenticationData: authTokens)
        }
    }
    
    //MARK: Utility
    
    private func encodeUser(name: String?, email: String, password: String) -> Data?{
        let newUser = User(name: name, email: email, password: password)
        var encodedNewUser: Data!
        do { encodedNewUser = try JSONEncoder().encode(newUser) }
        catch {
            PostAlerts.presentAlertController(viewController: self, titleMsg: "Encoding Error", errorMsg: error.localizedDescription)
            return nil
        }
        return encodedNewUser
    }
}


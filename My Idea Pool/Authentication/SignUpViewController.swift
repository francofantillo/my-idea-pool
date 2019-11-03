//
//  SignUpViewController.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-29.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import UIKit

class SignUpViewController: AuthenticationViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInOptionStackView: UIStackView!
    
    //MARK: - Class Varibles
    
    var delegate: LogInDelegate!
    var wasPresented = false
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardListeners()
        assignDelegates()
        configureKeyboard()
        wasPresented = self.isBeingPresented
        if self.wasPresented == true { logInOptionStackView.isHidden = true }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func assignDelegates(){
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //MARK: - Keyboard
    
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
    
    //MARK: - IBActions
    
    @IBAction func logInPressed(_ sender: Any) {
        presentLoginView()
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        
        let name = nameTextField.text!
        guard name != "" else {
            PostAlerts.presentAlertController(viewController: self, titleMsg: "Name Error", errorMsg: "Please enter a name.")
            return
        }
        guard let email = getNewEmail() else { return }
        guard let password = getNewPassword() else { return }
        guard let encodedNewUser = encodeNewUser(name: name, email: email, password: password) else { return }
        
        RESTApiManager.sharedInstance.makeAPICall(endPoint: Endpoints.signUp.rawValue , json: encodedNewUser, requestType: "POST", authToken: nil, completion: handleLoginResponse(data:error:))
    }
    
    //MARK: - New Email Error Handling
    
    private func getNewEmail() -> String? {
        let titleError = "Email Error"
        let emailString = emailTextField.text!
        var email: Email!
        do {
            email = try Email(emailString)
        } catch EvaluateEmailError.isEmpty {
            PostAlerts.presentAlertController(viewController: self, titleMsg: titleError, errorMsg: "Please enter an email address.")
            return nil
        } catch EvaluateEmailError.isNotValidEmailAddress {
            PostAlerts.presentAlertController(viewController: self, titleMsg: titleError, errorMsg: "Email address is not valid.")
            return nil
        } catch EvaluateEmailError.isNotValidEmailLength {
            PostAlerts.presentAlertController(viewController: self, titleMsg: titleError, errorMsg: "Email address must have less than 81 characters.")
            return nil
        } catch {
            PostAlerts.presentAlertController(viewController: self, titleMsg: titleError, errorMsg: error.localizedDescription)
            return nil
        }
        return email.address()
    }
    
    //MARK: - Password Error Handling
    
    private func getNewPassword() -> String? {
        
        let titleError = "Password Error"
        let passwordString = passwordTextField.text!
        var password: Password!
        do {
            password = try Password(passwordString)
        } catch EvaluatePasswordError.isEmpty {
            PostAlerts.presentAlertController(viewController: self, titleMsg: titleError, errorMsg: "Please enter a password.")
            return nil
        } catch {
            PostAlerts.presentAlertController(viewController: self, titleMsg: titleError, errorMsg: error.localizedDescription)
            return nil
        }
        return password.passwordString()
    }
    
    //MARK: - Utility
    
    private func encodeNewUser(name: String?, email: String, password: String) -> Data?{
        let newUser = User(name: name, email: email, password: password)
        var encodedNewUser: Data!
        do { encodedNewUser = try JSONEncoder().encode(newUser) }
        catch {
            PostAlerts.presentAlertController(viewController: self, titleMsg: "Encoding Error", errorMsg: error.localizedDescription)
            return nil
        }
        return encodedNewUser
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
            delegate.LogInDelegateFunc(tokenData: authTokens)
        } else {
            signInToApp(authenticationData: authTokens, insertIndex: 1)
        }
    }

}

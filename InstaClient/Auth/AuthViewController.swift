//
//  AuthViewController.swift
//  InstaClient
//
//  Created by Maksim Torburg on 15.05.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBAction func loginButtonPresssed(_ sender: Any) {
        if !email.hasText {
            presentAlert(forEmpty: "Email")
        }
        if !password.hasText {
            presentAlert(forEmpty: "Password")
        }
        let validator = FieldValidator()
        if validator.validate(email, password) {
            UserDefaults.standard.set(email.text, forKey: "UserName")
            UserDefaults.standard.set(password.text, forKey: "UserPassword")
            performSegue(withIdentifier: "authSuccess", sender: self)
        }
    }
    var activeTextField: UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setGesturesRecogrizers()
        setObservers()
    }
    
    func setGesturesRecogrizers() {
          let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
          view.addGestureRecognizer(tap)
    }

    func setObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        email.addTarget(self, action: #selector(loginButtonStateChange), for: .editingChanged)
        password.addTarget(self, action: #selector(loginButtonStateChange), for: .editingChanged)
    }
    
    @objc
    func loginButtonStateChange() {
        if email.hasText && password.hasText {
            login.alpha = 1
            login.isEnabled = true
        } else {
            login.alpha = 0.5
            login.isEnabled = false
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    func keyboardWillShow(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue  else {
            print("Can't get keyboardRect from \(notification)")
            return
        }
        
        let topOfKeyboard = view.frame.height - keyboardRect.height
        guard let textField = activeTextField else {
            return
        }
        guard let bottomOfTextField = textField.superview?.convert(textField.frame, to: view).maxY else {
            return
        }

        if bottomOfTextField > topOfKeyboard {
            view.frame.origin.y = -(bottomOfTextField - topOfKeyboard)
        }
    }
    
    @objc
    func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    func presentAlert(forEmpty sender: String) {
        let alertController = UIAlertController(title: "\(sender) can't be empty", message: "Fill it", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .destructive, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: view.window)
    }
}

// MARK: - UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        switch textField {
        case email:
            password.becomeFirstResponder()
        case password:
            if email.hasText {
                loginButtonPresssed(textField)
            } else {
                presentAlert(forEmpty: "Email")
            }
        default:
            view.resignFirstResponder()
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}

    

//
//  LoginViewController.swift
//  AC3.2-Final
//
//  Created by Tom Seymour on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidesWhenStopped = true
    }

    
    @IBAction func registerTapped(_ sender: UIButton) {
        
        animateButton(sender: registerButton)
        print("register")
        if let email = emailTextField.text, let password = passwordTextField.text {
            self.activityIndicator.startAnimating()
            registerButton.isEnabled = false
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
                if error != nil {
                    print("error with completion while creating new Authentication: \(error!)")
                }
                if user != nil {
                    // registraition succesful. 
                    self.activityIndicator.stopAnimating()
                    self.showOKAlert(title: "Registraition Successful.", message: nil) {
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                } else {
                    self.activityIndicator.stopAnimating()
                    self.showOKAlert(title: "Registraition Failed", message: error?.localizedDescription)
                }
                self.registerButton.isEnabled = true
            })
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        print("login")
        animateButton(sender: loginButton)
        if let username = emailTextField.text,
            let password = passwordTextField.text {
            self.activityIndicator.startAnimating()
            loginButton.isEnabled = false
            FIRAuth.auth()?.signIn(withEmail: username, password: password, completion: { (user: FIRUser?, error: Error?) in
                if error != nil {
                    print("Erro \(error)")
                }
                if user != nil {
                    print("SUCCESS.... \(user!.uid)")
                    self.activityIndicator.stopAnimating()
                    self.showOKAlert(title: "Login Successful.", message: nil) {
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    self.activityIndicator.stopAnimating()
                    self.showOKAlert(title: "Login Failed", message: error?.localizedDescription)
                }
                self.loginButton.isEnabled = true
            })
        }
    }
    
    
    // MARK: - Helper Fuctions.
    
    func showOKAlert(title: String, message: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
            if let completionAction = completion {
                    completionAction()
            }
        }
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func animateButton(sender: UIButton) {
        let newTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        let originalTransform = sender.imageView!.transform
        UIView.animate(withDuration: 0.1, animations: {
            sender.layer.transform = CATransform3DMakeAffineTransform(newTransform)
        }, completion: { (complete) in
            sender.layer.transform = CATransform3DMakeAffineTransform(originalTransform)
        })
    }


    
    
}

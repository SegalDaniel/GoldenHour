//
//  LoginViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 05/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.viewTapRecognizer(target: self.view, toBeTapped: self.view, action: #selector(UIView.endEditing(_:)))
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        let model = Model.instance
        if model.modelFirebase.checkIfSignIn(){
            usernameTextField.text = model.modelFirebase.getUserName()!
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        Model.instance.modelFirebase.signIn(mail: usernameTextField.text!, pass: passwordTextField.text!) { (user, error) in
            if user != nil{
                //print("signin succeed")
                self.performSegue(withIdentifier: "loggedInSegue", sender: nil)
            }
            else{
                let alert = SimpleAlert(_title: "Could not Sign In", _message: (error?.localizedDescription)!, dissmissCallback:{})
                self.present(alert.getAlert(), animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func registerPressed(_ sender: Any) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loggedInSegue"{
            Model.instance.getUserInfo(userId: Model.instance.getUserID()){ (user) in
                Model.connectedUser = user
            }
        }
    }
}

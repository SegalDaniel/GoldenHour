//
//  LoginViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 05/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        let model = Model.instance
        if model.modelFirebase.checkIfSignIn(){
            print(model.modelFirebase.getUserId() + " " + model.modelFirebase.getUserName()!)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        Model.instance.modelFirebase.signIn(mail: usernameTextField.text!, pass: passwordTextField.text!) { (Bool) in
            if Bool == true{
                print("signin succeed")
                self.performSegue(withIdentifier: "loggedInSegue", sender: nil)
            }
        }
    }
    
    @IBAction func registerPressed(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

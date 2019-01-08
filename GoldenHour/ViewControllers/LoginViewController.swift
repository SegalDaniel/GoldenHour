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
        Utility.viewTapRecognizer(target: self.view, toBeTapped: self.view, action: #selector(UIView.endEditing(_:)))

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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

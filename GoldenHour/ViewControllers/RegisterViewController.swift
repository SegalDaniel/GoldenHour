//
//  RegisterViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 05/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        let model = Model.instance
       
        model.modelFirebase.registerUser(mail: emailTextField.text!, pass: passwordTextField.text!) { (user ,error)  in
            if error != nil{
                let alert = SimpleAlert(_title: "Error", _message: error!.localizedDescription) {() in
                    print("alert dissmissed, user didn't registered")
                }
                self.present(alert.getAlert(), animated: true, completion: nil)
                
            }else{
                if model.modelFirebase.checkIfSignIn(){
                    let alert = SimpleAlert(_title: "Congratulations!", _message: "you have secessfully registered!"){() in
                        self.performSegue(withIdentifier: "RegisteredSegue", sender: nil)
                    }
                    self.present(alert.getAlert(), animated: true, completion: nil)
                }
                else{
                    self.dismiss(animated: true, completion: nil)
                }
                print("user register callback")
            }
            
        }
        
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

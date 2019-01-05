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
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
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

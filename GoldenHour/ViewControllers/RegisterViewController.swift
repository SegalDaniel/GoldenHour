//
//  RegisterViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 05/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var permissions:Permissions?
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.viewTapRecognizer(target: self.view, toBeTapped: self.view, action: #selector(UIView.endEditing(_:)))
        Utility.roundImageView(imageView: profileImageView)
        Utility.viewTapRecognizer(target: self, toBeTapped: profileImageView, action: #selector (imageTapped(tapGestureRecognizer:)))
        permissions = Permissions(target: self, imagePicker: imagePicker)
        imagePicker.delegate = self
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.view.endEditing(true)
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.permissions?.checkPermissionCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.permissions?.checkPermissionGallery()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        if usernameTextField.text == "" {
            let alert = SimpleAlert(_title: "Wait!", _message: "Please Enter an User Name") {}
            self.present(alert.getAlert(), animated: true, completion: nil)
        }

        else{
            let loadingView = Utility.getLoadingAlert(message: "Register in progress, please wait..")
            self.present(loadingView, animated: true, completion: nil)
            let newUser = User(_id: "", _userName: self.usernameTextField.text!, _password: self.passwordTextField.text!, _profileImage: "", _description: "", _email: self.emailTextField.text!, _post: [])
            Model.instance.addNewUser(user: newUser, profileImage: self.profileImageView.image, callback: { (error, reference) in
               //loadingView.removeFromParent()
                self.dismiss(animated: true, completion: nil)
                if error != nil{
                    let alert = SimpleAlert(_title: "Error", _message: error!.localizedDescription) {() in
                        print("alert dissmissed, user didn't registered")
                    }
                    self.present(alert.getAlert(), animated: true, completion: nil)
                    
                }
                else{
                    let alert = SimpleAlert(_title: "Congratulations!", _message: "you have secessfully registered!"){() in
                        self.performSegue(withIdentifier: "RegisteredSegue", sender: newUser)
                    }
                    self.present(alert.getAlert(), animated: true, completion: nil)
                }
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        profileImageView.image = image
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegisteredSegue"{
            Model.connectedUser = sender as? User
        }
    }
}

//
//  RegisterViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 05/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
        // Do any additional setup after loading the view.
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.image = image
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

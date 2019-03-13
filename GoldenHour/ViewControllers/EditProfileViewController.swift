//
//  EditProfileViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 10/03/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //MARK: - Variables
    @IBOutlet weak var saveImageBtn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    
    let imagePicker = UIImagePickerController()
    var user:User!
    var permissions:Permissions?
    
    //MARK: - Override UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        user = Model.connectedUser
        permissions = Permissions(target: self, imagePicker: imagePicker)
        imagePicker.delegate = self
        descTextField.delegate = self
        usernameTextField.delegate = self
        initViews()
    }
    
    //MARK: - Views init
    func initViews(){
        Utility.roundImageView(imageView: profileImageView)
        Model.instance.getImageKF(url: user.profileImage, imageView: self.profileImageView, placeHolderNamed: "profile_placeholder")
        saveImageBtn.isEnabled = false
    }
    
    //MARK: - Buttons actions
    @IBAction func changeImageBtnPressed(_ sender: Any) {
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
    
    @IBAction func saveImageBtnPressed(_ sender: Any) {
        let loadingView = Utility.getLoadingAlert(message: "Updating your image, please wait..")
        self.present(loadingView, animated: true, completion: nil)
        Model.instance.updateUserProfileImage(image: profileImageView.image!) { (err, ref) in
            let alert = SimpleAlert(_title: "Success", _message: "nice image you got there!", dissmissCallback: {}).getAlert()
            loadingView.dismiss(animated: true, completion: {
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func usernameSaveBtnPressed(_ sender: Any) {
        if let text = usernameTextField.text{
            if text != ""{
                Model.instance.updateUsername(new_name: text) { (err, ref) in
                    if err == nil{
                        let alert = SimpleAlert(_title: "Alright!", _message: "updated sucessfully") {}.getAlert()
                        self.present(alert, animated: true) {
                            self.usernameTextField.text = ""
                        }
                    }
                }
            }
            else{
                noTextAlert()
            }
        }
    }
    
    @IBAction func descBtnPressed(_ sender: Any) {
        if let text = descTextField.text{
            if text != ""{
                Model.instance.updateDescription(description: text) { (err, ref) in
                    if err == nil{
                        let alert = SimpleAlert(_title: "Alright!", _message: "updated sucessfully") {}.getAlert()
                        self.present(alert, animated: true) {
                            self.descTextField.text = ""
                        }
                    }
                }
            }
            else{
                noTextAlert()
            }
        }
    }
    
    //MARK: - UIImagePickerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        profileImageView.image = image
        saveImageBtn.backgroundColor = profileBtn.backgroundColor
        saveImageBtn.isEnabled = true
    }
    
    //MARK: - Logic Alert
    func noTextAlert(){
        let alert = SimpleAlert(_title: "Wait!", _message: "please fill the text field") {}.getAlert()
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == descTextField{
            guard let text = textField.text else { return true }
            let count = text.count + string.count - range.length
            if count > 20{
                let simpleAlert = SimpleAlert(_title: "Wait", _message: "no more then 20 chrachters allow") {
                    }.getAlert()
                self.present(simpleAlert, animated: true, completion: nil)
            }
            return count <= 20
        }
        else{
            guard let text = textField.text else { return true }
            let count = text.count + string.count - range.length
            if count > 15{
                let simpleAlert = SimpleAlert(_title: "Wait", _message: "no more then 15 chrachters allow") {
                    }.getAlert()
                self.present(simpleAlert, animated: true, completion: nil)
            }
            return count <= 15
        }
    }
}

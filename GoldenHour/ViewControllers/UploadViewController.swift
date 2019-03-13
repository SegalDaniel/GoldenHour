//
//  UploadViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 07/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit
import Photos

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - Variables
    @IBOutlet weak var selectImageLabel: UILabel!
    @IBOutlet weak var bigPlusImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    let imagePicker = UIImagePickerController()
    var permissions:Permissions?
    
    var x = 0
    var selctedImage: UIImage?
    var data:PhotosStaticData = PhotosStaticData()
    
    //MARK: - Override UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        allViewsToucable()
        imagePicker.delegate = self
        permissions = Permissions(target: self, imagePicker: imagePicker)
    }
    
    //MARK: - UIIMagePickerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        
        userImageView.contentMode = .scaleAspectFit
        userImageView.image = image
        self.selctedImage = image
        userImageView.isHidden = false
        selectImageLabel.isHidden = true
        bigPlusImageView.isHidden = true
    }

    //MARK: - Buttons actions
    @IBAction func editImagePressed(_ sender: Any) {
        selectImageTapped()
    }
    
    @objc func selectImageTapped(){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.permissions?.checkPermissionCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.permissions?.checkPermissionGallery()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //addInfo segue
        let vc = segue.destination as! AddPostInfoViewController
        if let img = selctedImage{
            vc.userImage = img
        }
        vc.data = nil
        userImageView.isHidden = true
        selectImageLabel.isHidden = false
        bigPlusImageView.isHidden = false
     }
    
    // MARK: - Init Views
    func allViewsToucable(){
        Utility.viewTapRecognizer(target: self, toBeTapped: self.view, action: #selector(self.selectImageTapped))
        Utility.viewTapRecognizer(target: self, toBeTapped: bigPlusImageView, action: #selector(self.selectImageTapped))
        Utility.viewTapRecognizer(target: self, toBeTapped: selectImageLabel, action: #selector(self.selectImageTapped))
    }
}

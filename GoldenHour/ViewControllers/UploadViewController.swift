//
//  UploadViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 07/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit
import Photos

class UploadViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var camManPicker: UIPickerView!
    @IBOutlet weak var camModelPicker: UIPickerView!
    @IBOutlet weak var lensModelPicker: UIPickerView!
    
    let imagePicker = UIImagePickerController()
    
    var x = 0
    var selctedImage: UIImage?
    let cameraManufacture = ["Camera Manufacture", "Canon", "Fujifilm", "Nikon", "Sony"]
    let cameraModels = [
        ["Camera Model"],
        ["200D", "300D", "350D", "400D", "450D", "500D", "550D", "600D", "650D", "700D", "750D"],["XT-100", "X100T", "X100F", "XT-10", "XT-20", "XT-1", "XT-2", "XT-3", "XH-1", "XPRO-1", "XPRO-2"],
        ["nikon models"],
        ["sony models"]
    ]
    let lensModels = [
        ["Lens Model"],
        ["Canon Lenses"],
        ["Fujinon Lenses"],
        ["Nikon Lenses"],
        ["Sony Lenses"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        camManPicker.delegate = self
        camManPicker.dataSource = self
        camModelPicker.delegate = self
        camModelPicker.dataSource = self
        lensModelPicker.delegate = self
        lensModelPicker.dataSource = self
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (imageTapped(tapGestureRecognizer:)))
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.checkPermissionCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.checkPermissionGallery()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkPermissionCamera(){
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                self.openCamera()
            }
            else{
                let alert = UIAlertController( title: "GoldenHour Would Like To Access the Camera", message: "Go To Settings -> \nGoldenHour -> Camera", preferredStyle: .alert )
                let dissmisAction = UIAlertAction(title: "Dissmis", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(dissmisAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func checkPermissionGallery(){
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
            openGallery()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    print("success")
                    self.openGallery()
                }
            })
            print("It is not determined until now")
        case .restricted:
            print("User do not have access to photo album.")
        case .denied:
            print("User has denied the permission.")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        userImageView.contentMode = .scaleAspectFit
        userImageView.image = image
        self.selctedImage = image
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch (pickerView){
        case camManPicker:
            return cameraManufacture.count
        case camModelPicker:
            return cameraModels[x].count
        case lensModelPicker:
            return lensModels[x].count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch (pickerView){
        case camManPicker:
            return cameraManufacture[row]
        case camModelPicker:
            return cameraModels[x][row]
        case lensModelPicker:
            return lensModels[x][row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == camManPicker {
            x = row
            camModelPicker.reloadAllComponents()
            lensModelPicker.reloadAllComponents()
        }
    }
    
    func openCamera(){
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func openGallery(){
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
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

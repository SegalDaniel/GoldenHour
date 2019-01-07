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
    @IBOutlet weak var aptPicker: UIPickerView!
    @IBOutlet weak var shutterPicker: UIPickerView!
    
    let imagePicker = UIImagePickerController()
    
    var x = 0
    var selctedImage: UIImage?
    let data:PhotosStaticData = PhotosStaticData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        camManPicker.delegate = self
        camManPicker.dataSource = self
        camModelPicker.delegate = self
        camModelPicker.dataSource = self
        lensModelPicker.delegate = self
        lensModelPicker.dataSource = self
        imagePicker.delegate = self
        //imagePicker.sourceType = .photoLibrary
        aptPicker.delegate = self
        aptPicker.dataSource = self
        shutterPicker.delegate = self
        shutterPicker.dataSource = self
        
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
    
    @IBAction func uploadPressed(_ sender: Any) {
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
            return data.cameraManufacture.count
        case camModelPicker:
            return data.cameraModels[x].count
        case lensModelPicker:
            return data.lensModels[x].count
        case aptPicker:
            return data.aptRange.count
        case shutterPicker:
            return data.shutterRange.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch (pickerView){
        case camManPicker:
            return data.cameraManufacture[row]
        case camModelPicker:
            return data.cameraModels[x][row]
        case lensModelPicker:
            return data.lensModels[x][row]
        case aptPicker:
            return data.aptRange[row]
        case shutterPicker:
            return data.shutterRange[row]
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

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

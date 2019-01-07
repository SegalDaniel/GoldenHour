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
        ["EF 8-15mm f/4L Fisheye USM","EF-S 10-22mm f/3.5-4.5 USM","EF-S 10-18mm f/4.5-5.6 IS STM","EF 11-24mm f/4L USM","EF 14mm f/2.8L II USM","EF 16-35mm f/2.8L III USM","EF 16-35mm f/2.8L II USM","EF 16-35mm f/4L IS USM","EF 17-40mm f/4L USM","EF-S 15-85mm f/3.5-5.6 IS USM","EF-S 18-55mm f/4-5.6 IS STM","TS-E 17mm f/4L","EF-S 17-55 f/2.8 IS USM","EF-S 17-85mm f/4-5.6 IS USM","EF-S 18-55mm f/3.5-5.6 IS II","EF-S 18-55mm f/3.5-5.6 IS STM","EF-S 18-135mm f/3.5-5.6 IS","EF-S 18-135mm f/3.5-5.6 IS STM","EF-S 18-135mm f/3.5-5.6 IS USM","EF-S 18-200mm f/3.5-5.6 IS","EF 20mm f/2.8 USM","EF-S 24mm f/2.8 STM","EF 24mm f/2.8 IS USM","EF 24mm f/1.4L II USM","TS-E 24mm f/3.5L II","EF 24-70mm f/2.8L II USM","EF 24-70mm f/4L IS USM","EF 24-105mm f/3.5-5.6 IS STM","EF 24-105mm f/4L IS II USM","EF 24-105mm f/4L IS USM","EF 28mm f/2.8 IS USM","EF 28 f/1.8 USM","EF 28-135mm f/3.5-5.6 IS USM","EF 28-300mm f/3.5-5.6L IS USM","EF 35mm f/1.4L II USM","EF 35mm f/2 IS USM","EF 35mm f/1.4L USM","EF 40mm f/2.8 STM","TS-E 45mm f/2.8","EF 50mm f/1.8 STM","EF 50mm f/1.2L USM","EF 50mm f/1.4 USM","EF 50mm f/1.8 II","EF 50mm f/2.5","TS-E 50mm f/2.8L Macro","EF-S 55-250mm f/4-5.6 IS II","EF-S 55-250mm f/4-5.6 IS STM","EF-S 60mm f/2.8 Macro USM","MP-E 65mm f/2.8 1-5x Macro Photo","EF 70-200mm f/2.8L IS II USM","EF 70-200mm f/2.8L USM","EF 70-200mm f/4L IS USM","EF 70-200mm f/4L USM","EF 70-300mm f/4.5-5.6 DO IS USM","EF 70-300mm f/4-5.6 IS II USM","EF 70-300mm f/4-5.6L IS USM","EF 70-300mm f/4-5.6 IS USM","EF 75-300mm f/4-5.6 III","EF 75-300mm f/4-5.6 III USM","EF 85mm f/1.2L II USM","EF 85mm f/1.4L IS USM","EF 85mm f/1.8 USM","TS-E 90mm f/2.8","EF 100mm f/2.8L Macro IS USM","EF 100mm f/2.8 Macro USM","EF 100-400mm f/4.5-5.6L IS II USM","EF 100-400mm f/4.5-5.6L IS USM","EF 135mm f/2L USM","TS-E 135mm f/4L Macro","EF 180mm f/3.5L Macro USM","EF 200mm f/2L IS USM","EF 200mm f/2.8L II USM","EF 200-400mm f/4L IS USM Extender 1.4x","EF 300mm f/4L IS USM","EF 300mm f/2.8L IS USM","EF 300mm f/2.8L IS II USM","EF 400mm f/4 DO IS II USM","EF 400mm f/2.8L IS II USM","EF 400mm f/5.6L USM","EF 400mm f/4 DO IS USM","EF 500mm f/4L IS II USM","EF 600mm f/4L IS II USM","EF 800mm f/5.6L IS USM"],
        ["Fujinon Lenses"],
        ["AF-S DX 10-24mm f/3.5-4.5G ED","AF-S DX Zoom 12-24mm f/4G IF-ED","AF-S 14-24mm f/2.8G ED","AF-S 16-35mm f/4G ED VR","AF-S Zoom 17-35mm f/2.8D IF-ED","AF Zoom 18-35mm f/3.5-4.5D IF-ED","AF-S 18-35mm f/3.5-4.5G ED","AF-S DX Zoom 18-55mm f/3.5-5.6G ED II","AF-S DX 18-55mm f/3.5-5.6G VR","AF-S DX 16-85mm f/3.5-5.6G ED VR","AF-S DX Zoom 17-55mm f/2.8G IF-ED","AF-S DX 18-105mm f/3.5-5.6G ED VR","AF-S DX 18-140mm f/3.5-5.6G ED VR","AF-S DX 18-200mm f/3.5-5.6G ED VR II","AF-S DX 18-300mm f/3.5-5.6G ED VR","AF-S 24-70mm f/2.8G ED","AF Zoom 24-85mm f/2.8-4D IF","AF-S 24-85mm f/3.5-4.5G ED VR","AF-S 24-120mm f/4G ED VR","AF-S 28-300mm f/3.5-5.6G ED VR","AF-S DX Zoom 55-200mm f/4-5.6G ED","AF-S DX VR Zoom 55-200mm f/4-5.6G IF-ED","AF-S DX 55-300mm f/4.5-5.6G ED VR","AF-S 70-200mm f/2.8G ED VR II","AF-S 70-200mm f/4G ED VR","AF Zoom 70-300mm f/4-5.6G","AF-S VR Zoom 70-300mm f/4.5-5.6G IF-ED","AF Zoom 80-200mm f/2.8D ED","AF VR Zoom 80-400mm f/4.5-5.6D ED","AF-S 80-400mm f/4.5-5.6G ED VR","AF-S 200-400mm f/4G ED VR II","AF 14mm f/2.8D ED","AF 20mm f/2.8D","AF-S 24mm f/1.4G ED","AF 24mm f/2.8D","AF-S 28mm f/1.8G","AF-S 35mm f/1.4G","AF 35mm f/2D","AF-S DX 35mm f/1.8G","AF 50mm f/1.4D","AF-S 50mm f/1.4G","AF 50mm f/1.8D","AF-S 50mm f/1.8G","AF-S 50mm f/1.8G (Special Edition)","AF-S 58mm f/1.4G","AF 85mm f/1.4D IF","AF-S 85mm f/1.4G","AF 85mm f/1.8D","AF-S 85mm f/1.8G","AF DC 105mm f/2D","AF DC 135mm f/2D","AF 180mm f/2.8D IF-ED","AF-S 200mm f/2G ED VR II","AF-S 300mm f/2.8G ED VR II","AF-S 300mm f/4D IF-ED","AF-S 400mm f/2.8G ED VR","AF-S 500mm f/4G ED VR","AF-S 600mm f/4G ED VR","AF-S 800mm f/5.6E FL ED VR","AF-S DX Micro 40mm f/2.8G","AF Micro 60mm f/2.8D","AF-S Micro 60mm f/2.8G ED","AF-S DX Micro 85mm f/3.5G ED VR","AF-S VR Micro 105mm f/2.8G IF-ED","AF Micro 200mm f/4D IF-ED","AF DX Fisheye 10.5mm f/2.8G ED","AF Fisheye 16mm f/2.8D","PC-E 24mm f/3.5D ED","PC-E Micro 45mm f/2.8D ED","PC-E Micro 85mm f/2.8D", "20mm f/2.8", "24mm f/2.8", "28mm f/2.8", "35mm f/1.4", "50mm f/1.2", "50mm f/1.4","Micro 55mm f/2.8","Micro 105mm f/2.8"],
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

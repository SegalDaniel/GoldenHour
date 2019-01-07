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
        ["EOS 200D","EOS 300D","EOS 350D","EOS 400D","EOS 450D","EOS 500D","EOS 550D","EOS 650D","EOS 700D","EOS 750D","EOS 760D","EOS 800D","EOS 100D","EOS 200D","EOS 1000D","EOS 1100D","EOS 1200D","EOS 1300D","EOS 1500D","EOS 4000D","EOS 77D","EOS D30","EOS D60","EOS 10D","EOS 20D","EOS 20Da","EOS 30D","EOS 40D","EOS 50D","EOS 60D","EOS 60Da","EOS 70D","EOS 77D","EOS 80D","EOS 7D","EOS 7D Mark II","EOS 5D","EOS 5D Mark II","EOS 5D Mark III","EOS 5D Mark IV","EOS 5Ds EOS 5Ds R","EOS 6D","EOS 6D Mark II","EOS-1D","EOS-1Ds","EOS-1D Mark II","EOS-1Ds Mark II","EOS-1D Mark II N","EOS-1D Mark III","EOS-1Ds Mark III","EOS-1D","Mark IV","EOS-1D X","EOS-1D X Mark II","EOS-1D C","Canon EOS M","Canon EOS M2","Canon EOS M3","Canon EOS M10","Canon EOS M5","Canon EOS M6","Canon EOS M100","Canon EOS M50","Canon EOS R"],
        ["X-H1","X-Pro2","X-T","X-T2","X-T20","X-T10","X-E","X-A5","X-A","X100F","XF10","GFX 50S","GFX 50R"],["D3X","D2Xs","D2X","D1X","D1","D5","D4S","D4","D3S","D3","D2Hs","D2H","D1H","D850","D810","D800","D700","D750","D610","D600","D500","D300S","D300","D200","D100","D7500","D7200","D7100","D7000","D90","D80","D70s","D70","D5600","D5500","D5300","D5200","D5100","D5000","D60","D40X","D50","D3500","D3400","D3300","D3200","D3100","D3000","D40"],
        ["Sony α900","Sony α850","Sony α99","Sony α99 II","Sony α100","Sony α700","Sony α200","Sony α300","Sony α350","Sony α230","Sony α330","Sony α380","Sony α500","Sony α550","Sony α450","Sony α290","Sony α390","Sony α560","Sony α580","Sony α33","Sony α55","Sony α35","Sony α65","Sony α77","Sony α57","Sony α37","Sony α58","Sony α77 II","Sony α68","Sony NEX-3","Sony NEX-5","Sony NEX-C3","Sony NEX-5N","Sony NEX-7","Sony NEX-F3","Sony NEX-5R","Sony NEX-6","Sony NEX-3N","Sony NEX-5T","Sony α3000","Sony α7","Sony α7R","Sony α5000","Sony α6000","Sony α3500","Sony α7S","Sony α5100","Sony α7 II","Sony α7R II","Sony α6300","Sony α6500","Sony α9","Sony α7R III","Sony α7 III","Sony αQX1"]
    ]
    let lensModels = [
        ["Lens Model"],
        ["EF 8-15mm f/4L Fisheye USM","EF-S 10-22mm f/3.5-4.5 USM","EF-S 10-18mm f/4.5-5.6 IS STM","EF 11-24mm f/4L USM","EF 14mm f/2.8L II USM","EF 16-35mm f/2.8L III USM","EF 16-35mm f/2.8L II USM","EF 16-35mm f/4L IS USM","EF 17-40mm f/4L USM","EF-S 15-85mm f/3.5-5.6 IS USM","EF-S 18-55mm f/4-5.6 IS STM","TS-E 17mm f/4L","EF-S 17-55 f/2.8 IS USM","EF-S 17-85mm f/4-5.6 IS USM","EF-S 18-55mm f/3.5-5.6 IS II","EF-S 18-55mm f/3.5-5.6 IS STM","EF-S 18-135mm f/3.5-5.6 IS","EF-S 18-135mm f/3.5-5.6 IS STM","EF-S 18-135mm f/3.5-5.6 IS USM","EF-S 18-200mm f/3.5-5.6 IS","EF 20mm f/2.8 USM","EF-S 24mm f/2.8 STM","EF 24mm f/2.8 IS USM","EF 24mm f/1.4L II USM","TS-E 24mm f/3.5L II","EF 24-70mm f/2.8L II USM","EF 24-70mm f/4L IS USM","EF 24-105mm f/3.5-5.6 IS STM","EF 24-105mm f/4L IS II USM","EF 24-105mm f/4L IS USM","EF 28mm f/2.8 IS USM","EF 28 f/1.8 USM","EF 28-135mm f/3.5-5.6 IS USM","EF 28-300mm f/3.5-5.6L IS USM","EF 35mm f/1.4L II USM","EF 35mm f/2 IS USM","EF 35mm f/1.4L USM","EF 40mm f/2.8 STM","TS-E 45mm f/2.8","EF 50mm f/1.8 STM","EF 50mm f/1.2L USM","EF 50mm f/1.4 USM","EF 50mm f/1.8 II","EF 50mm f/2.5","TS-E 50mm f/2.8L Macro","EF-S 55-250mm f/4-5.6 IS II","EF-S 55-250mm f/4-5.6 IS STM","EF-S 60mm f/2.8 Macro USM","MP-E 65mm f/2.8 1-5x Macro Photo","EF 70-200mm f/2.8L IS II USM","EF 70-200mm f/2.8L USM","EF 70-200mm f/4L IS USM","EF 70-200mm f/4L USM","EF 70-300mm f/4.5-5.6 DO IS USM","EF 70-300mm f/4-5.6 IS II USM","EF 70-300mm f/4-5.6L IS USM","EF 70-300mm f/4-5.6 IS USM","EF 75-300mm f/4-5.6 III","EF 75-300mm f/4-5.6 III USM","EF 85mm f/1.2L II USM","EF 85mm f/1.4L IS USM","EF 85mm f/1.8 USM","TS-E 90mm f/2.8","EF 100mm f/2.8L Macro IS USM","EF 100mm f/2.8 Macro USM","EF 100-400mm f/4.5-5.6L IS II USM","EF 100-400mm f/4.5-5.6L IS USM","EF 135mm f/2L USM","TS-E 135mm f/4L Macro","EF 180mm f/3.5L Macro USM","EF 200mm f/2L IS USM","EF 200mm f/2.8L II USM","EF 200-400mm f/4L IS USM Extender 1.4x","EF 300mm f/4L IS USM","EF 300mm f/2.8L IS USM","EF 300mm f/2.8L IS II USM","EF 400mm f/4 DO IS II USM","EF 400mm f/2.8L IS II USM","EF 400mm f/5.6L USM","EF 400mm f/4 DO IS USM","EF 500mm f/4L IS II USM","EF 600mm f/4L IS II USM","EF 800mm f/5.6L IS USM"],
        ["XF14mmF2.8 R","XF16mmF1.4 R WR","XF18mmF2 R","XF23mmF1.4 R","XF23mmF2 R WR","XF27mmF2.8","XF35mmF1.4 R","XF35mmF2 R WR","XF50mmF2 R WR","XF56mmF1.2 R","XF56mmF1.2 R APD","XF60mmF2.4 R Macro","XF80mmF2.8 R LM OIS WR Macro","XF90mmF2 R LM WR","XF200mmF2 R LM OIS WR","XF8-16mmF2.8 R LM WR","XF10-24mmF4 R OIS","XF16-55mmF2.8 R LM WR","XF18-55mmF2.8-4 R LM OIS","XF18-135mmF3.5-5.6 R LM OIS WR","XF50-140mmF2.8 R LM OIS WR","XF55-200mmF3.5-4.8 R LM OIS","XF100-400mmF4.5-5.6 R LM OIS WR","XC15-45mmF3.5-5.6 OIS PZ","XC16-50mmF3.5-5.6 OIS II","XC50-230mmF4.5-6.7 OIS II","MKX18-55mmT2.9","MKX50-135mmT2.9"],
        ["AF-S DX 10-24mm f/3.5-4.5G ED","AF-S DX Zoom 12-24mm f/4G IF-ED","AF-S 14-24mm f/2.8G ED","AF-S 16-35mm f/4G ED VR","AF-S Zoom 17-35mm f/2.8D IF-ED","AF Zoom 18-35mm f/3.5-4.5D IF-ED","AF-S 18-35mm f/3.5-4.5G ED","AF-S DX Zoom 18-55mm f/3.5-5.6G ED II","AF-S DX 18-55mm f/3.5-5.6G VR","AF-S DX 16-85mm f/3.5-5.6G ED VR","AF-S DX Zoom 17-55mm f/2.8G IF-ED","AF-S DX 18-105mm f/3.5-5.6G ED VR","AF-S DX 18-140mm f/3.5-5.6G ED VR","AF-S DX 18-200mm f/3.5-5.6G ED VR II","AF-S DX 18-300mm f/3.5-5.6G ED VR","AF-S 24-70mm f/2.8G ED","AF Zoom 24-85mm f/2.8-4D IF","AF-S 24-85mm f/3.5-4.5G ED VR","AF-S 24-120mm f/4G ED VR","AF-S 28-300mm f/3.5-5.6G ED VR","AF-S DX Zoom 55-200mm f/4-5.6G ED","AF-S DX VR Zoom 55-200mm f/4-5.6G IF-ED","AF-S DX 55-300mm f/4.5-5.6G ED VR","AF-S 70-200mm f/2.8G ED VR II","AF-S 70-200mm f/4G ED VR","AF Zoom 70-300mm f/4-5.6G","AF-S VR Zoom 70-300mm f/4.5-5.6G IF-ED","AF Zoom 80-200mm f/2.8D ED","AF VR Zoom 80-400mm f/4.5-5.6D ED","AF-S 80-400mm f/4.5-5.6G ED VR","AF-S 200-400mm f/4G ED VR II","AF 14mm f/2.8D ED","AF 20mm f/2.8D","AF-S 24mm f/1.4G ED","AF 24mm f/2.8D","AF-S 28mm f/1.8G","AF-S 35mm f/1.4G","AF 35mm f/2D","AF-S DX 35mm f/1.8G","AF 50mm f/1.4D","AF-S 50mm f/1.4G","AF 50mm f/1.8D","AF-S 50mm f/1.8G","AF-S 50mm f/1.8G (Special Edition)","AF-S 58mm f/1.4G","AF 85mm f/1.4D IF","AF-S 85mm f/1.4G","AF 85mm f/1.8D","AF-S 85mm f/1.8G","AF DC 105mm f/2D","AF DC 135mm f/2D","AF 180mm f/2.8D IF-ED","AF-S 200mm f/2G ED VR II","AF-S 300mm f/2.8G ED VR II","AF-S 300mm f/4D IF-ED","AF-S 400mm f/2.8G ED VR","AF-S 500mm f/4G ED VR","AF-S 600mm f/4G ED VR","AF-S 800mm f/5.6E FL ED VR","AF-S DX Micro 40mm f/2.8G","AF Micro 60mm f/2.8D","AF-S Micro 60mm f/2.8G ED","AF-S DX Micro 85mm f/3.5G ED VR","AF-S VR Micro 105mm f/2.8G IF-ED","AF Micro 200mm f/4D IF-ED","AF DX Fisheye 10.5mm f/2.8G ED","AF Fisheye 16mm f/2.8D","PC-E 24mm f/3.5D ED","PC-E Micro 45mm f/2.8D ED","PC-E Micro 85mm f/2.8D", "20mm f/2.8", "24mm f/2.8", "28mm f/2.8", "35mm f/1.4", "50mm f/1.2", "50mm f/1.4","Micro 55mm f/2.8","Micro 105mm f/2.8"],
        ["E 16mm F2.8","E 20mm F2.8","E 24mm F1.4","Carl Zeiss Sonnar T* E 24mm F1.8 ZA","FE 28mm F2","E 30mm F3.5 Macro","Zeiss Distagon T* FE 35mm F1.4 ZA","E 35mm F1.8 OSS","Carl Zeiss Sonnar T* FE 35mm F2.8 ZA","Zeiss Planar T* FE 50mm F1.4 ZA","E 50mm F1.8 OSS","FE 50mm F1.8","FE 50mm F2.8 Macro","Carl Zeiss Sonnar T* FE 55mm F1.8 ZA","FE 85mm F1.4 GM","FE 85mm F1.8","FE 90mm F2.8 Macro G OSS","FE 100mm F2.8 STF GM OSS","E 10-18mm F4 OSS","FE 12-24mm F4 G","FE 16-35mm F2.8 GM","Zeiss Vario-Tessar T* FE 16-35mm F4 ZA OSS","E PZ 16-50mm F3.5-5.6 OSS","Carl Zeiss Vario-Tessar T* E 16-70mm F4 ZA OSS","E 18-50mm F4-5.6","E 18-55mm F3.5-5.6 OSS","E PZ 18-105mm F4 G OSS","E PZ 18-110mm F4 G OSS","E 18-135mm F3.5-5.6 OSS","E 18-200mm F3.5-6.3 OSS","E 18-200mm F3.5-6.3 OSS","E PZ 18-200mm F3.5-6.3 OSS","Carl Zeiss Vario-Tessar T* FE 24-70mm F4 ZA OSS","FE 24-70mm F2.8 GM","FE 24-105mm F4 G OSS","FE 24-240mm F3.5-6.3 OSS","FE 28-70mm F3.5-5.6 OSS","FE PZ 28-135mm F4 G OSS","E 55-210mm F4.5-6.3 OSS","FE 70-200mm F4 G OSS","FE 70-200mm F2.8 GM OSS","FE 70-300mm F4.5-5.6 G OSS","FE 100-400mm F4.5-5.6 GM OSS"]
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
                let alert = SimpleAlert(_title: "GoldenHour Would Like To Access the Camera", _message: "Go To Settings -> \nGoldenHour -> Camera"){() in
                    
                }
                self.present(alert.getAlert(), animated: true, completion: nil)
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

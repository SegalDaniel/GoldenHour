//
//  Permissions.swift
//  GoldenHour
//
//  Created by Zach Bachar on 07/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import Foundation
import Photos
import AVKit

class Permissions{
    
    let target:UIViewController
    let imagePicker:UIImagePickerController
    
    init(target:UIViewController, imagePicker:UIImagePickerController) {
        self.target = target
        self.imagePicker = imagePicker
    }
    
    func checkPermissionCamera(){
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                self.openCamera()
            }
            else{
                let alert = SimpleAlert(_title: "GoldenHour Would Like To Access the Camera", _message: "Go To Settings -> \nGoldenHour -> Camera"){() 
                }
                self.target.present(alert.getAlert(), animated: true, completion: nil)
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
    
    func openCamera(){
        imagePicker.sourceType = .camera
        target.present(imagePicker, animated: true, completion: nil)
    }
    
    func openGallery(){
        imagePicker.sourceType = .photoLibrary
        target.present(imagePicker, animated: true, completion: nil)
    }
}

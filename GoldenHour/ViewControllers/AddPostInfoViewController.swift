//
//  AddPostInfoViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 10/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class AddPostInfoViewController: UIViewController, MyPickerDelegate, UITextFieldDelegate {

    @IBOutlet weak var descritionTextField: UITextField!
    @IBOutlet weak var extnAccTextField: UITextField!
    @IBOutlet weak var camManLabel: UILabel!
    @IBOutlet weak var camModelLabel: UILabel!
    @IBOutlet weak var lensModelLabel: UILabel!
    @IBOutlet weak var aptLabel: UILabel!
    @IBOutlet weak var ssLabel: UILabel!
    @IBOutlet weak var addLocLabel: UILabel!
    @IBOutlet weak var camManBtn: UIButton!
    @IBOutlet weak var camModelBtn: UIButton!
    @IBOutlet weak var lensBtn: UIButton!
    @IBOutlet weak var aptBtn: UIButton!
    @IBOutlet weak var ssBtn: UIButton!
    @IBOutlet weak var addLocBtn: UIButton!
    
    
    
    //let pickerVC = PickerViewController()
    var userImage:UIImage?
    var imageData:PhotosStaticData = PhotosStaticData()
    var pickerData:[String]?
    var pickedMan:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.viewTapRecognizer(target: self.view, toBeTapped: self.view, action: #selector(UIView.endEditing(_:)))
        descritionTextField.delegate = self
        extnAccTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func camManBtnPressed(_ sender: Any) {
        pickerData = imageData.cameraManufacture
        self.performSegue(withIdentifier: "picker", sender: sender)
        //self.view.isHidden = true
    }
    
    @IBAction func camModelBtnPressed(_ sender: Any) {
        if let x = pickedMan{
            pickerData = imageData.cameraModels[x]
            self.performSegue(withIdentifier: "picker", sender: sender)
            //self.view.isHidden = true
        }
        else{
            selectManAlert()
        }
    }
    
    @IBAction func lensBtnPressed(_ sender: Any) {
        if let x = pickedMan{
            pickerData = imageData.lensModels[x]
            self.performSegue(withIdentifier: "picker", sender: sender)
            //self.view.isHidden = true
        }
        else{
            selectManAlert()
        }
    }
    
    @IBAction func aptBtnPressed(_ sender: Any) {
        pickerData = imageData.aptRange
        self.performSegue(withIdentifier: "picker", sender: sender)
        //self.view.isHidden = true
    }
    
    @IBAction func ssBtnPressed(_ sender: Any) {
        pickerData = imageData.shutterRange
        self.performSegue(withIdentifier: "picker", sender: sender)
        //self.view.isHidden = true
    }
    
    @IBAction func addLocBtnPressed(_ sender: Any) {
    }
    
    @IBAction func uploadBtnPressed(_ sender: Any) {
        if userImage != nil{
            Model.instance.modelFirebase.saveImage(image: userImage!, name: "test") { (url) in
                print("callback from upload image")
                let alert = SimpleAlert(_title: "WooHoo", _message: "Image uploaded seccfully", dissmissCallback: {
                    self.performSegue(withIdentifier: "fullScreenSegue", sender: url)
                })
                self.present(alert.getAlert(), animated: true, completion: nil)
            }
        }
    }
    
    
    func selectManAlert(){
        let alert = SimpleAlert(_title: "Wait!", _message: "Please Select Manufacturer First") {}
        self.present(alert.getAlert(), animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "picker"{
            let vc = segue.destination as! PickerViewController
            vc.delegate = self
            vc.sentWith = sender as? UIButton
            vc.data = pickerData
        }
        else if segue.identifier == "fullScreenSegue"{
            let vc = segue.destination as! FullScreenImageViewController
            vc.hidesBottomBarWhenPushed = true
            vc.url = sender as? String
        }
    }
    
    func userPickedProperty(sender: UIButton?, property: String?) {
        if sender != nil && property != nil{
            switch sender!{
            case camManBtn:
                camManLabel.text = property!
                pickedMan = imageData.cameraManufacture.firstIndex(of: property!)
                break
            case camModelBtn:
                camModelLabel.text = property!
                break
            case lensBtn:
                lensModelLabel.text = property!
                break
            case aptBtn:
                aptLabel.text = "f/" + property!
                break
            case ssBtn:
                ssLabel.text = "Shutter Speed: " + property!
                break
            default: break
                
            }
        }
        //self.view.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}

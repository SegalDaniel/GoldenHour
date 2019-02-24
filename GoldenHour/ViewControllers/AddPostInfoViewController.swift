//
//  AddPostInfoViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 10/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit
import CoreLocation

class AddPostInfoViewController: UIViewController, MyPickerDelegate, UITextFieldDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var descritionTextField: UITextField!
    @IBOutlet weak var extnAccTextField: UITextField!
    @IBOutlet weak var camManLabel: UILabel!
    @IBOutlet weak var camModelLabel: UILabel!
    @IBOutlet weak var lensModelLabel: UILabel!
    @IBOutlet weak var aptLabel: UILabel!
    @IBOutlet weak var ssLabel: UILabel!
    @IBOutlet weak var addLocLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var extLabel: UILabel!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var camManBtn: UIButton!
    @IBOutlet weak var camModelBtn: UIButton!
    @IBOutlet weak var lensBtn: UIButton!
    @IBOutlet weak var aptBtn: UIButton!
    @IBOutlet weak var ssBtn: UIButton!
    @IBOutlet weak var addLocBtn: UIButton!
    
    var data:Metadata?
    
    var userImage:UIImage?
    var imageData:PhotosStaticData = PhotosStaticData()
    var pickerData:[String]?
    var pickedMan:Int?
    var locationManager:CLLocationManager!
    var location:String?
    var metaInfo:[String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.viewTapRecognizer(target: self.view, toBeTapped: self.view, action: #selector(UIView.endEditing(_:)))
        descritionTextField.delegate = self
        extnAccTextField.delegate = self
        hideBtns()
        // Do any additional setup after loading the view.
    }

    @IBAction func camManBtnPressed(_ sender: Any) {
        pickerData = imageData.cameraManufacture
        self.performSegue(withIdentifier: "picker", sender: sender)
    }
    
    @IBAction func camModelBtnPressed(_ sender: Any) {
        if let x = pickedMan{
            pickerData = imageData.cameraModels[x]
            self.performSegue(withIdentifier: "picker", sender: sender)
        }
        else{
            selectManAlert()
        }
    }
    
    @IBAction func lensBtnPressed(_ sender: Any) {
        if let x = pickedMan{
            pickerData = imageData.lensModels[x]
            self.performSegue(withIdentifier: "picker", sender: sender)
        }
        else{
            selectManAlert()
        }
    }
    
    @IBAction func aptBtnPressed(_ sender: Any) {
        pickerData = imageData.aptRange
        self.performSegue(withIdentifier: "picker", sender: sender)
    }
    
    @IBAction func ssBtnPressed(_ sender: Any) {
        pickerData = imageData.shutterRange
        self.performSegue(withIdentifier: "picker", sender: sender)
    }
    
    @IBAction func addLocBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Location", message: "Please select preffered location insertation", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Current", style: .default, handler: { (action) in
            if let loc = self.location{
                self.addLocLabel.text = loc
                self.metaInfo["loc"] = loc
            }
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Manually", style: .default, handler: { (action) in
            let secondAlert = UIAlertController(title: "Location", message: nil, preferredStyle: .alert)
            secondAlert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "insert location"
            })
            secondAlert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { (action) in
                self.addLocLabel.text = secondAlert.textFields?[0].text
                self.metaInfo["loc"] = secondAlert.textFields?[0].text
                secondAlert.dismiss(animated: true, completion: nil)
            }))
            self.present(secondAlert, animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func uploadBtnPressed(_ sender: Any) {
        let meta = getMetaInfo()
        if userImage != nil && meta.0{
            let loadingView = Utility.getLoadingAlert(message: "Uploading your post, please wait..")
            self.present(loadingView, animated: true, completion: nil)
            let postID = "\(Model.connectedUser!.id)\(Model.connectedUser!.post.count)"
            let post = Post(_userId: Model.connectedUser!.id, _postId:postID, _title: descritionTextField.text!, _imageUrl: nil, metadata: meta.1!)
            Model.instance.savePostImage(image: userImage!, name: postID) { (url) in
                post.imageUrl = url
                Model.instance.addNewPost(post: post) { (error, ref) in
                    print("new post at \(ref)")
                    self.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "unwindToWall", sender: nil)
                }
            }
        }
        else{
            let alert = SimpleAlert(_title: "Wait", _message: "Please select an image and fill all necessary fields") {}
            self.present(alert.getAlert(), animated: true, completion: nil)
        }
    }
    
    
    func getMetaInfo()->(Bool,Metadata?){
        if metaInfo.count < 5{
            return (false, nil)
        }
        if metaInfo["man"] == nil || metaInfo["model"] == nil || metaInfo["lens"] == nil ||
            metaInfo["apt"] == nil || metaInfo["ss"] == nil{
            return (false, nil)
        }
        
        return (true, Metadata(_manufacturer: metaInfo["man"]!, _model: metaInfo["model"]!, _lens: metaInfo["lens"]!, _shutterSpeed: metaInfo["ss"]!, _aperture: metaInfo["apt"]!, _description: metaInfo["desc"]!,_externalAccesssories: metaInfo["ext"], _location: metaInfo["loc"]))
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
        else if segue.identifier == "unwindToWall"{
            var navigationArray = self.navigationController?.viewControllers //To get all UIViewController stack as Array
            navigationArray!.remove(at: (navigationArray?.count)! - 1) // To remove previous UIViewController
            let vc = navigationArray!.first! as! UploadViewController
            vc.userImageView.image = nil
            vc.userImageView.isHidden = true
            vc.selectImageLabel.isHidden = false
            vc.bigPlusImageView.isHidden = false
            self.navigationController?.viewControllers = []
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func userPickedProperty(sender: UIButton?, property: String?) {
        if sender != nil && property != nil{
            switch sender!{
            case camManBtn:
                camManLabel.text = property!
                metaInfo["man"] = property!
                pickedMan = imageData.cameraManufacture.firstIndex(of: property!)
                break
            case camModelBtn:
                camModelLabel.text = property!
                metaInfo["model"] = property!
                break
            case lensBtn:
                lensModelLabel.text = property!
                metaInfo["lens"] = property!
                break
            case aptBtn:
                aptLabel.text = "f/" + property!
                metaInfo["apt"] = property!
                break
            case ssBtn:
                ssLabel.text = "Shutter Speed: " + property!
                metaInfo["ss"] = property!
                break
            default: break
                
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == descritionTextField{
            metaInfo["desc"] = textField.text
        }
        else if textField == extnAccTextField{
            metaInfo["ext"] = textField.text
        }
    }
    
    func hideBtns(){
        if let data = data{
            camManBtn.isHidden = true
            camModelBtn.isHidden = true
            lensBtn.isHidden = true
            aptBtn.isHidden = true
            ssBtn.isHidden = true
            addLocBtn.isHidden = true
            descLabel.isHidden = false
            descritionTextField.isHidden = true
            extLabel.isHidden = false
            extnAccTextField.isHidden = true
            uploadBtn.isHidden = true
            
            camManLabel.text = data.manufacturer
            camModelLabel.text = data.model
            lensModelLabel.text = data.lens
            aptLabel.text = data.aperture
            ssLabel.text = data.shutterSpeed
            addLocLabel.text = data.location ?? "No Location"
            descLabel.text = data.description
            extLabel.text = data.externalAccesssories ?? "No Accessories"
            
        }
        else{
            locationInit()
            camManBtn.isHidden = false
            camModelBtn.isHidden = false
            lensBtn.isHidden = false
            aptBtn.isHidden = false
            ssBtn.isHidden = false
            addLocBtn.isHidden = false
            descLabel.isHidden = true
            extLabel.isHidden = true
            descritionTextField.isHidden = false
            extnAccTextField.isHidden = false
            uploadBtn.isHidden = false
        }
    }
    
    /******************************** Location stuff *********************************/
    func locationInit(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let userLocation :CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality ?? "")
                print(placemark.administrativeArea ?? "")
                print(placemark.country ?? "")
                
                self.location = "\(placemark.locality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.country ?? "")"
                self.locationManager.stopUpdatingLocation()
            }
        }
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}

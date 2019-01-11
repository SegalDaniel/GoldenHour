//
//  PickerViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 09/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var data:[String]?
    var delegate:MyPickerDelegate?
    var selectedRow:Int?
    var sentWith:UIButton?
    @IBOutlet weak var dataPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataPickerView.delegate = self
        dataPickerView.dataSource = self
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let d = data{
            return d.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let d = data{
            return d[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = row
    }
    
    @IBAction func savePressed(_ sender: Any) {
        if data != nil && selectedRow != nil && selectedRow != 0 && sentWith != nil{
            delegate?.userPickedProperty(sender: sentWith!, property: data![selectedRow!])
        }
        else{
            delegate?.userPickedProperty(sender: nil, property: nil)
        }
        self.navigationController?.navigationBar.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        let width:CGFloat  = self.view.bounds.width/1.3
        let height:CGFloat = self.view.bounds.height/1.8
        let x:CGFloat      = self.view.center.x - (width/2)
        let y:CGFloat      = self.view.center.y - (height/2)
        let frame:CGRect   = CGRect(x: x, y: y, width: width, height: height)
        
        self.view.frame = frame
        self.view.dropShadow()
    }

}

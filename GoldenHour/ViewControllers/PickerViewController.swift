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
        if data != nil && selectedRow != nil && sentWith != nil{
            delegate?.userPickedProperty(sender: sentWith!, property: data![selectedRow!])
        }
        else{
            delegate?.userPickedProperty(sender: nil, property: nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        let navBarHeight             = self.navigationController?.navigationBar.frame.size.height
        
        print("statusBarHeight: \(statusBarHeight) navBarHeight: \(String(describing: navBarHeight))")
        
        // view
        let x:CGFloat      = self.view.bounds.origin.x
        let y:CGFloat      = self.view.bounds.origin.y //+ statusBarHeight + 100//+ CGFloat(navBarHeight!)
        let width:CGFloat  = self.view.bounds.width
        let height:CGFloat = self.view.bounds.height //- statusBarHeight - 30 //- CGFloat(navBarHeight!)
        let frame:CGRect   = CGRect(x: x, y: y, width: width, height: height)
        
        print("x: \(x) y: \(y) width: \(width) height: \(height)")
        
        self.view.frame = frame
        //self.view.layer.cornerRadius = self.view.frame.height/6
        //self.view.backgroundColor = UIColor.red
    }

}

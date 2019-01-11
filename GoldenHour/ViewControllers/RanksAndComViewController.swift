//
//  RanksAndComViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 11/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class RanksAndComViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    

    @IBOutlet weak var ranksLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var addCommTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        Utility.viewTapRecognizer(target: self.view, toBeTapped: self.view, action: #selector(UIView.endEditing(_:)))
        addCommTextField.delegate = self
        commentsTableView.drawBorder(width: 2)
        Utility.moveWithKeyboard(viewController: self)
        addPostBtn()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentsTableViewCell
        // Configure the cell...
        
        
        return cell
    }
    
    @IBAction func refresh(_ sender: Any) {
        if let btn = sender as? UIButton{
            btn.setTitleColor(UIColor.gray, for: .normal)
            btn.isEnabled = false
            print("post pressed")
        }
        
    }
    
    func addPostBtn(){
        let button = UIButton(type: .custom)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont(name: "PfennigBold", size: UIFont.labelFontSize)
        //button.setImage(UIImage(named: "send.png"), for: .normal)
        //button.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
        button.frame = CGRect(x: CGFloat(addCommTextField.frame.size.width - 45), y: CGFloat(15), width: CGFloat(45), height: CGFloat(15))
        button.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
        addCommTextField.rightView = button
        addCommTextField.rightViewMode = .whileEditing
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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

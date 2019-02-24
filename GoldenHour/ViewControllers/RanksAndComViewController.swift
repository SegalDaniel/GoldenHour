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
    
    var postId:String?
    var comments:[Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        Utility.viewTapRecognizer(target: self.view, toBeTapped: self.view, action: #selector(UIView.endEditing(_:)))
        addCommTextField.delegate = self
        commentsTableView.drawBorder(width: 2)
        Utility.moveWithKeyboard(viewController: self)
        addPostBtn()
        setLogoTitle()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    func refreshComments(){
        if let id = postId{
            Model.instance.getAllCommentsOfPost(postId: id) { (data) in
                self.comments = data
                self.commentsTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentsTableViewCell
        // Configure the cell...
        cell.commentLabel.text = comments[indexPath.row].comment
        cell.userId = comments[indexPath.row].userId
        return cell
    }
    
    @IBAction func refresh(_ sender: Any) {
        if let btn = sender as? UIButton{
            btn.setTitleColor(UIColor.gray, for: .normal)
            btn.isEnabled = false
            if let text = addCommTextField.text{
                if text == "" {return}
                let loadingView = Utility.getLoadingAlert(message: "Uploading Comment")
                self.present(loadingView, animated: true, completion: nil)
                let com = Comment(_commentId: "\(postId!)\(comments.count)", _userId:Model.connectedUser!.id, _comment: text, _userName: Model.connectedUser!.userName)
                Model.instance.addCommentToPost(postId: postId!, comment: com) { (err, ref) in
                    self.dismiss(animated: true, completion: {
                        self.refreshComments()
                        self.addCommTextField.endEditing(true)
                        self.addCommTextField.text = nil
                        btn.setTitleColor(UIColor.blue, for: .normal)
                        btn.isEnabled = true
                    })
                }
            }
        }
        
    }
    
    func addPostBtn(){
        let button = UIButton(type: .custom)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont(name: "PfennigBold", size: UIFont.labelFontSize)
        button.frame = CGRect(x: CGFloat(addCommTextField.frame.size.width - 45), y: CGFloat(15), width: CGFloat(45), height: CGFloat(15))
        button.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
        addCommTextField.rightView = button
        addCommTextField.rightViewMode = .whileEditing
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}

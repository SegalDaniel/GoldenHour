//
//  MyProfileViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 12/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit
import Kingfisher
class MyProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, postCollectionViewCellDelegate {

    //MARK: - Variables
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDescLabel: UILabel!
    @IBOutlet weak var userPostsCollection: UICollectionView!
    var user:User?
    var posts:[Post] = []
    var showBtns:Bool = true
    var connectedUserListener:NSObjectProtocol?
    
    //MARK: - Override UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        userPostsCollection.delegate = self
        userPostsCollection.dataSource = self
        Utility.roundImageView(imageView: profileImageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideButtons()
    }

    deinit{
        if connectedUserListener != nil{
            ModelNotification.connectedUser.remove(observer: connectedUserListener!)
        }
    }
    
    //MARK: - UICollectionViewDelegate and Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userPostCell", for: indexPath) as! PostCollectionViewCell
        cell.awakeFromNib()
        Model.instance.getImageKF(url: posts[indexPath.row].imageUrl!, imageView: cell.postImageView)
        cell.post = posts[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    //MARK: - postCollectionViewCellDelegate
    func longPressed(post: Post) {
        if !showBtns {return}
        let alert = UIAlertController(title: "Hey!", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            let simpleAlert = SimpleAlert(_title: "Deleted Sucessfully", _message: "", dissmissCallback: {
                self.userPostsCollection.reloadData()
            }).getAlert()
            Model.instance.removePost(post: post, callback: { (error, ref) in
                alert.dismiss(animated: true, completion: {})
                self.present(simpleAlert, animated: true, completion: nil)
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func tapped(post: Post) {
        self.performSegue(withIdentifier: "fullScreenImageSegue", sender: post)
    }
    
    
    //MARK: - Buttons actions
    @IBAction func editProfileBtnPressed(_ sender: Any) {
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        let result:(Bool, Error?) = Model.instance.modelFirebase.sign_Out()
        if result.0{
            print("signed out")
            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
        }
        else{
            let alert = SimpleAlert(_title: "Error!", _message: (result.1?.localizedDescription ?? "Error Occured Please Try Again")) {}
            self.present(alert.getAlert(), animated: true, completion: nil)
        }
    }
    
    //MARK: - Update content
    func loadPosts(){
        if let user = user{
            posts = []
            user.post.forEach { (postId) in
                Model.instance.getPost(postId: postId, callback: { (post) in
                    if self.posts.count < user.post.count{
                        self.posts.append(post)
                        self.userPostsCollection.reloadData()
                    }
                })
            }
            Model.instance.getImageKF(url: user.profileImage, imageView: self.profileImageView, placeHolderNamed: "profile_placeholder")
            self.userNameLabel.text = user.userName
            self.userDescLabel.text = user.description
        }
    }
    
    //MARK: - Views init
    func hideButtons(){
        if !showBtns{
            logoutBtn.isHidden = true
            editProfileBtn.isHidden = true
            loadPosts()
        }
        else{
            connectedUserListener = ModelNotification.connectedUser.observe(cb: { (user) in
                self.user = user
                self.loadPosts()
            })
            Model.instance.updateConnectedUser()
            logoutBtn.isHidden = false
            editProfileBtn.isHidden = false
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fullScreenImageSegue"{
            let vc = segue.destination as! FullScreenImageViewController
            vc.hidesBottomBarWhenPushed = true
            vc.post = sender as? Post
        }
        else if segue.identifier == "logoutSegue"{
            
        }
    }
}

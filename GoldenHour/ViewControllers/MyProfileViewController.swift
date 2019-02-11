//
//  MyProfileViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 12/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDescLabel: UILabel!
    @IBOutlet weak var userPostsCollection: UICollectionView!
    var user:User?
    var posts:[Post] = []
    var postsImages:[UIImage] = []
    var showBtns:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPostsCollection.delegate = self
        userPostsCollection.dataSource = self
        Utility.roundImageView(imageView: profileImageView)
        hideButtons()
        loadPosts()
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsImages.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userPostCell", for: indexPath) as! PostCollectionViewCell
        cell.image = postsImages[indexPath.row]
        cell.post = posts[indexPath.row]
        cell.awakeFromNib()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userPostCell", for: indexPath) as! PostCollectionViewCell
        self.performSegue(withIdentifier: "fullScreenImageSegue", sender: cell.image)
    }
    
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
    
    func loadPosts(){
        if let user = user{
            Model.instance.getImage(url: user.profileImage) { (image) in
                if let image = image{
                    self.profileImageView.image = image
                }
            }
            userNameLabel.text = user.userName
            user.post.forEach { (postId) in
                Model.instance.getPost(postId: postId, callback: { (post, image) in
                    self.posts.append(post)
                    self.postsImages.append(image)
                    self.userPostsCollection.reloadData()
                })
            }
        }
    }
    
    func hideButtons(){
        if !showBtns{
            logoutBtn.isHidden = true
            editProfileBtn.isHidden = true
        }
        else{
            user = Model.connectedUser
            logoutBtn.isHidden = false
            editProfileBtn.isHidden = false
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     //fullScreenImageSegue , logoutSegue
        if segue.identifier == "fullScreenImageSegue"{
            let vc = segue.destination as! FullScreenImageViewController
            vc.hidesBottomBarWhenPushed = true
            vc.image = sender as? UIImage
        }
        else if segue.identifier == "logoutSegue"{
            
        }
    }
    
    
    

}

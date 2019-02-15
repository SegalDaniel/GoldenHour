//
//  FullScreenImageViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 08/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController {

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var fullScreenImageView: UIImageView!
    @IBOutlet weak var imageInfoBtn: UIButton!
    @IBOutlet weak var commentsBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    var post:Post?
    var url:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullScreenImageView.contentMode = .scaleAspectFit
        setImage()
        setLogoTitle()
        toggleHiddenViews()
        Utility.viewTapRecognizer(target: self, toBeTapped: fullScreenImageView, action: #selector(toggleHiddenViews))
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isHidden = false
        self.footerView.isHidden = true
    }
    
    @IBAction func imageInfoBtnPressed(_ sender: Any) {
    }
    
    @IBAction func commentsBtnPressed(_ sender: Any) {
    }
    
    @IBAction func sharedBtnPressed(_ sender: Any) {
    }
    
    func setImage(){
        if let post = post{
            Model.instance.getImageKF(url: post.imageUrl!, imageView: fullScreenImageView)
        }
    }
    
    @objc func toggleHiddenViews(){
        if footerView.isHidden{
            footerView.isHidden = !footerView.isHidden
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            UIView.animate(withDuration: 0.5, animations: {
                self.footerView.alpha = 1.0
                //self.footerView.frame.origin.y = self.footerView.frame.origin.y - 100
                self.navigationController?.navigationBar.isHidden = false
            }
            )}
        else{
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            UIView.animate(withDuration: 0.5, animations: {
                self.footerView.alpha = 0
                //self.footerView.frame.origin.y = self.footerView.frame.origin.y + 100
            }) { (bool) in
                self.footerView.isHidden = !self.footerView.isHidden
                self.navigationController?.navigationBar.isHidden = true
            }
        }
    }
    
    func roundFooter(){
        footerView.layer.borderWidth = 1
        footerView.layer.masksToBounds = false
        footerView.layer.borderColor = UIColor.white.cgColor
        footerView.layer.cornerRadius = footerView.frame.height/2
        footerView.clipsToBounds = true
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails"{
            let vc = segue.destination as! AddPostInfoViewController
            vc.data = post?.metaData
        }
    }
    

}

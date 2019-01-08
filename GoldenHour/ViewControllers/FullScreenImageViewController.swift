//
//  FullScreenImageViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 08/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController {

    @IBOutlet weak var fullScreenImageView: UIImageView!
    var image:UIImage?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if image != nil && fullScreenImageView.image != image{
            fullScreenImageView.contentMode = .scaleAspectFit
            fullScreenImageView.image = image
            print("image arrived")
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.navigationController?.navigationBar.isHidden = false
    }
    @IBAction func xBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
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

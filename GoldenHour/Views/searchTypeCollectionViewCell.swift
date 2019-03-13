//
//  searchTypeCollectionViewCell.swift
//  GoldenHour
//
//  Created by Zach Bachar on 11/03/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class searchTypeCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Variables
    var delegate:searchTypeCollectionCellDelegate?
    var title:String?{
        didSet{
            if let btn = btn{
                btn.setTitle(title!, for: .normal)
            }
        }
    }
    @IBOutlet weak var btn: UIButton!
    var data:PhotosStaticData.nameSearchTitles?{
        didSet{
            if let btn = btn{
                btn.tag = data!.rawValue
            }
        }
    }
    
    //MARK: - Override UICollectionViewCell Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        if let data = data{
            btn.tag = data.rawValue
        }
        if let title = title{
            btn.setTitle(title, for: .normal)
        }
    }
    
    //MARK: - Buttons actions
    @IBAction func btnPressed(_ sender: Any) {
        delegate?.pressed(type: data!, sender: sender as! UIButton)
    }
}


//
//  SearchViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 11/03/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate ,searchTypeCollectionCellDelegate, MyPickerDelegate, searchTableViewCellDelegate {
 
    //MARK: - Varibales
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var mainTextField: UITextField!
    @IBOutlet weak var optionsCollectionView: UICollectionView!
    @IBOutlet weak var searchBtn: UIButton!
    
    let data = PhotosStaticData()
    var pickerData:[String]?
    var pickedMan:Int?
    var titles:[String]!
    var searchInfo:[String:String] = [:]
    
    var postsListener:NSObjectProtocol?
    var usersListener:NSObjectProtocol?
    var posts:[Post]?
    var users:[User]?
    var filterdPosts:[Post]?
    var filterdUsers:[User]?
    
    //MARK: - Override UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.viewTapRecognizer(target: self.view, toBeTapped: self.view, action: #selector(UIView.endEditing(_:)))
        optionsCollectionView.delegate = self
        optionsCollectionView.dataSource = self
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        mainTextField.delegate = self
        titles = data.searchTitles
        postsListener = ModelNotification.postsListNotification.observe(cb: { (posts) in
            self.posts = posts
        })
        usersListener = ModelNotification.usersListNotification.observe(cb: { (users) in
            self.users = users
        })
        Model.instance.getAllPosts()
        Model.instance.getAllUsers()
    }
    
    //MARK: - CollectionViewDelegate and Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchType", for: indexPath) as! searchTypeCollectionViewCell
        cell.data = PhotosStaticData.nameSearchTitles(rawValue: indexPath.row)
        cell.title = titles[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    //MARK: - searchTypeCollectionCellDelegate
    func pressed(type: PhotosStaticData.nameSearchTitles, sender: UIButton) {
        var showPicker:Bool = true
        switch type {
        case .Manufacture:
            pickerData = data.cameraManufacture
            break
        case .Model:
            if let x = pickedMan{
                pickerData = data.cameraModels[x]
            }
            else{
                showPicker = false
                showSelectManALert()
            }
            break
        case .Lens:
            if let x = pickedMan{
                pickerData = data.lensModels[x]
            }
            else{
                showPicker = false
                showSelectManALert()
            }
            break
        case .Apt:
            pickerData = data.aptRange
            break
        case .SS:
            pickerData = data.shutterRange
            break
        
        }
        if showPicker{
            self.performSegue(withIdentifier: "picker", sender: sender)
        }
    }
    
    //MARK: - MyPickerDelegate
    func userPickedProperty(sender: UIButton?, property: String?) {
        if sender != nil && property != nil{
            let type = PhotosStaticData.nameSearchTitles(rawValue: sender!.tag)!
            switch type{
            case .Manufacture:
                clearSearch()
                pickedMan = data.cameraManufacture.firstIndex(of: property!)
                searchInfo["man"] = property!
                break
            case .Model:
                searchInfo["model"] = property!
                break
            case .Lens:
                searchInfo["lens"] = property!
                break
            case .Apt:
                searchInfo["apt"] = property!
                break
            case .SS:
                searchInfo["ss"] = property!
            }
            sender!.setTitle(property!, for: .normal)
            titles[type.rawValue] = property!
        }
    }
    
    
    //MARK: - Results TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterdPosts != nil && filterdPosts!.count > 0{
            return filterdPosts!.count
        }
        if filterdUsers != nil && filterdUsers!.count > 0{
            return filterdUsers!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "search cell", for: indexPath) as! SearchTableViewCell
        if filterdPosts != nil && filterdPosts!.count > 0{
            cell.post = filterdPosts![indexPath.row]
            cell.user = nil
        }
        else if filterdUsers != nil && filterdUsers!.count > 0{
            cell.user = filterdUsers![indexPath.row]
            cell.post = nil
        }
        cell.delegate = self
        return cell
    }
    
    //MARK: - Logic Alert
    func showSelectManALert(){
        let alert = SimpleAlert(_title: "Wait!", _message: "Please select manufacture") {}.getAlert()
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Buttons actions
    @IBAction func refreshBtnPressed(_ sender: Any) {
        clearSearch()
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        filterdPosts = []
        filterdUsers = []
        resultsTableView.reloadData()
        
        //search by users
        if mainTextField.text != nil && mainTextField.text != "" && !textFieldShouldReturn(mainTextField){
            let userName = mainTextField.text!
            if let users = users{
                filterdUsers = users.filter({ (usr) -> Bool in
                    if usr.userName.contains(userName){
                        return true
                    }
                    return false
                })
            }
        }
            
        //search posts
        else{
            if let posts = posts {
                //search by metadata
                filterdPosts = posts
                
                if let man = searchInfo["man"]{
                    filterdPosts = filterdPosts!.filter({ (post) -> Bool in
                        if post.metaData.manufacturer == man{
                            return true
                        }
                        return false
                    })
                }
                if let mod = searchInfo["model"]{
                    filterdPosts = filterdPosts!.filter({ (post) -> Bool in
                        if post.metaData.model == mod{
                            return true
                        }
                        return false
                    })
                }
                if let lens = searchInfo["lens"]{
                    filterdPosts = filterdPosts!.filter({ (post) -> Bool in
                        if post.metaData.lens == lens{
                            return true
                        }
                        return false
                    })
                }
                if let apt = searchInfo["apt"]{
                    filterdPosts = filterdPosts!.filter({ (post) -> Bool in
                        if post.metaData.aperture == apt{
                            return true
                        }
                        return false
                    })
                }
                if let ss = searchInfo["ss"]{
                    filterdPosts = filterdPosts!.filter({ (post) -> Bool in
                        if post.metaData.shutterSpeed == ss{
                            return true
                        }
                        return false
                    })
                }
                
                filterdPosts!.sort(by: { (post1, post2) -> Bool in
                    post1.date > post2.date
                })
            }
        }
        
        clearSearch()
        optionsCollectionView.reloadData()
        resultsTableView.reloadData()
        
        if filterdPosts!.count == 0 && filterdUsers!.count == 0{
            let alert = SimpleAlert(_title: "Oh No!", _message: "Nothing found, try another search") {}.getAlert()
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    func clearSearch(){
        pickedMan = nil
        searchInfo = [:]
        titles = data.searchTitles
        mainTextField.text = ""
        optionsCollectionView.reloadData()
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "picker"{
            let vc = segue.destination as! PickerViewController
            vc.delegate = self
            vc.sentWith = sender as? UIButton
            vc.data = pickerData
        }
        else if segue.identifier == "displayPost"{
            let vc = segue.destination as! FullScreenImageViewController
            vc.hidesBottomBarWhenPushed = true
            vc.post = sender as? Post
        }
        else if segue.identifier == "displayUser"{
            let vc = segue.destination as! MyProfileViewController
            vc.user = sender as? User
            vc.showBtns = false
        }
    }
    
    //MARK: - searchTableViewCellDelegate
    func pressed(post: Post?, user: User?) {
        if let user = user{
            self.performSegue(withIdentifier: "displayUser", sender: user)
        }
        else if let post = post{
            self.performSegue(withIdentifier: "displayPost", sender: post)
        }
    }
    

}

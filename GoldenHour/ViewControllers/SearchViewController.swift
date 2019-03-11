
//
//  SearchViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 11/03/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, searchTypeCollectionCellDelegate, MyPickerDelegate {
    
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var mainTextField: UITextField!
    @IBOutlet weak var optionsCollectionView: UICollectionView!
    @IBOutlet weak var searchBtn: UIButton!
    
    let data = PhotosStaticData()
    var pickerData:[String]?
    var pickedMan:Int?
    var titles:[String]!
    var searchInfo:[String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsCollectionView.delegate = self
        optionsCollectionView.dataSource = self
        titles = data.searchTitles
    }
    
    //MARK: - CollectionView
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
    
    //MARK: - search Type cell delegate
    func pressed(type: PhotosStaticData.nameSearchTitles, sender: UIButton) {
        switch type {
        case .Manufacture:
            pickerData = data.cameraManufacture
            break
        case .Model:
            if let x = pickedMan{
                pickerData = data.cameraModels[x]
            }
            else{ showSelectManALert() }
            break
        case .Lens:
            if let x = pickedMan{
                pickerData = data.lensModels[x]
            }
            else{ showSelectManALert() }
            break
        case .Apt:
            pickerData = data.aptRange
            break
        case .SS:
            pickerData = data.shutterRange
            break
        
        }
        self.performSegue(withIdentifier: "picker", sender: sender)
    }
    
    //MARK: - My picker delegate
    func userPickedProperty(sender: UIButton?, property: String?) {
        if sender != nil && property != nil{
            let type = PhotosStaticData.nameSearchTitles(rawValue: sender!.tag)!
            switch type{
            case .Manufacture:
                pickedMan = data.cameraManufacture.firstIndex(of: property!)
                searchInfo["man"] = property!
                //need to reset the model and lens!
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "search cell", for: indexPath) as! SearchTableViewCell
        return cell
    }
    
    func showSelectManALert(){
        let alert = SimpleAlert(_title: "Wait!", _message: "Please select manufacture") {}.getAlert()
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        print(searchInfo)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "picker"{
            let vc = segue.destination as! PickerViewController
            vc.delegate = self
            vc.sentWith = sender as? UIButton
            vc.data = pickerData
        }
    }
    

}

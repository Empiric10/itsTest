//
//  WithTableViewController.swift
//  testITS
//
//  Created by Daniil Shlapak on 13.01.22.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: -Outlets
    @IBOutlet weak var reloadButton: UIImageView!
    @IBOutlet weak var collectionPresentationButton: UIImageView!
    @IBOutlet weak var tablePresentationButton: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var genderSelection: UISegmentedControl!
    @IBOutlet weak var sortByAgeUpButton: UIImageView!
    @IBOutlet weak var sortByAgeDownButton: UIImageView!
    @IBOutlet weak var loadBlur: UIVisualEffectView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Lets
    
    let mainViewModel = MainViewModel()
    
    //MARK: -Vars
    var sortByAgeUp = true
    var filteredArray: [PeopleList] = []{
        didSet{
            peopleCollectionView.reloadData()
            peopleTableView.reloadData()
            self.loadBlur.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    var dataArray : [PeopleList] = []{
        didSet {
            filteredArray = dataArray
            peopleCollectionView.reloadData()
            peopleTableView.reloadData()
        }
    }
    var peopleTableView = UITableView()
    var peopleCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupTableView()
    }
    
    //MARK: - Flow funcs
    private func configure(){
        self.setupGestureRecognizer()
        self.peopleTableView.delegate = self
        self.peopleTableView.dataSource = self
        self.peopleCollectionView.delegate = self
        self.peopleCollectionView.dataSource = self
        self.mainViewModel.dataArray.bind { list in
            self.dataArray = list
        }
        self.mainViewModel.getData()
    }
    
    private func setupGestureRecognizer(){
        let upSortByAgeRecognizer = UITapGestureRecognizer(target: self, action: #selector(sortUpAgeButtonPressed))
        self.sortByAgeUpButton.addGestureRecognizer(upSortByAgeRecognizer)
        
        let downSortByAgeRecognizer = UITapGestureRecognizer(target: self, action: #selector(sortDownAgeButtonPressed))
        self.sortByAgeDownButton.addGestureRecognizer(downSortByAgeRecognizer)
        
        let tablePresentationButtonRecognizer = UITapGestureRecognizer(target: self, action: #selector(setupTableView))
        self.tablePresentationButton.addGestureRecognizer(tablePresentationButtonRecognizer)
        
        let collectionPresentationButtonRecognizer = UITapGestureRecognizer(target: self, action: #selector(setupCollectionView))
        self.collectionPresentationButton.addGestureRecognizer(collectionPresentationButtonRecognizer)
        
        let reloadDataRecognizer = UITapGestureRecognizer(target: self, action: #selector(reloadData))
        self.reloadButton.addGestureRecognizer(reloadDataRecognizer)
    }
    
    private func openDetailsVC(index: Int){
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else{return}
        controller.customerData = self.filteredArray[index]
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
//MARK: - IBActions
extension MainViewController {
    @IBAction func setupTableView(){
        self.tablePresentationButton.tintColor = .systemBlue
        self.collectionPresentationButton.tintColor = .systemGray
        if self.view.subviews.contains(peopleCollectionView) {
           peopleCollectionView.removeFromSuperview()
        }
        self.peopleTableView.frame = self.backgroundView.frame
        self.peopleTableView.backgroundColor = .clear

        self.peopleTableView.register(UINib.init(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
        self.peopleTableView.reloadData()
        self.view.addSubview(peopleTableView)
    }
    
    @IBAction func setupCollectionView(){
        self.tablePresentationButton.tintColor = .systemGray
        self.collectionPresentationButton.tintColor = .systemBlue
        if self.view.subviews.contains(peopleTableView) {
            peopleTableView.removeFromSuperview()
        }
        self.peopleCollectionView.frame = self.backgroundView.frame
        self.peopleCollectionView.backgroundColor = .clear
        self.peopleCollectionView.register(UINib.init(nibName: "MainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MainCollectionViewCell")
        self.peopleCollectionView.reloadData()
        self.view.addSubview(peopleCollectionView)
    }
    
    @IBAction func sortUpAgeButtonPressed() {
        self.sortByAgeUp = true
        self.sortByAgeDownButton.tintColor = .systemGray
        self.sortByAgeUpButton.tintColor = .systemBlue
        filteredArray.sort { firstList, SecondList in
            firstList.age < SecondList.age
        }
    }
    
    @IBAction func sortDownAgeButtonPressed() {
        self.sortByAgeUp = false
        self.sortByAgeDownButton.tintColor = .systemBlue
        self.sortByAgeUpButton.tintColor = .systemGray
        filteredArray.sort { firstList, SecondList in
            firstList.age > SecondList.age
        }
    }
    
    @IBAction func changeGenderSelection(_ sender: UISegmentedControl) {
        let array = dataArray.sorted { element1, element2 in
            if sortByAgeUp {
                return element1.age < element2.age
            }else {
                return element1.age > element2.age
            }
        }
        
        switch genderSelection.selectedSegmentIndex{
        case 0:
            self.filteredArray = array
        case 1:
            self.filteredArray.removeAll()

            self.filteredArray = mainViewModel.filterGenderArray(array: array, condition: "male")
        case 2:
            self.filteredArray.removeAll()
            self.filteredArray = mainViewModel.filterGenderArray(array: array, condition: "female")
        default:
            print("Error")
        }
    }
    
    @IBAction func reloadData(){
        self.dataArray.removeAll()
        self.filteredArray.removeAll()
        self.loadBlur.isHidden = false
        self.activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.mainViewModel.getData()
        }
    }
}
//MARK: -TableView delegates
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath)
                as? MainTableViewCell else {return UITableViewCell()}
        let peopleData = self.filteredArray[indexPath.row]
        cell.configure(name: peopleData.name, age: String(peopleData.age), gender: peopleData.gender)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.openDetailsVC(index: indexPath.row)
    }
}
//MARK: -CollectionView delegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else {return UICollectionViewCell()}
        let peopleData = self.filteredArray[indexPath.item]
        cell.configure(name: peopleData.name, age: String(peopleData.age), gender: peopleData.gender)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (self.peopleCollectionView.frame.size.width - 25) / 2
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.openDetailsVC(index: indexPath.item)
    }
}

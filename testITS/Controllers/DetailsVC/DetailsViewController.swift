//
//  ExmapleViewController.swift
//  testITS
//
//  Created by Daniil Shlapak on 15.01.22.
//

import UIKit

class DetailsViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    //MARK: - Lets
    
    //MARK: - Vars
    var customerData : PeopleList?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    //MARK: - Flow funcs
    private func configure(){
        guard let customerInfo = customerData else {return}
        self.nameLabel.text = customerInfo.name
        self.ageLabel.text = "Age: \(String(customerInfo.age))"
        self.genderLabel.text = "Gender: \(customerInfo.gender)"
        self.phoneLabel.text = "Phone: \(customerInfo.phone)"
        self.addressLabel.text = "Address: \(customerInfo.address)"
        self.emailLabel.text = "Email: \(customerInfo.email)"
        self.companyLabel.text = "Company: \(customerInfo.company)"
        self.aboutLabel.text = "About: \(customerInfo.about)"
    }

}
//MARK: - IBActions
extension DetailsViewController {
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

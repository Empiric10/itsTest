//
//  MainCollectionViewCell.swift
//  testITS
//
//  Created by Daniil Shlapak on 14.01.22.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    func configure(name: String, age: String, gender: String){
        self.nameLabel.text = name
        self.ageLabel.text = "Age: \(age)"
        self.genderLabel.text = "Gender: \(gender)"
        self.borderView.layer.borderColor = UIColor.white.cgColor
        self.borderView.layer.borderWidth = 1
    }
}

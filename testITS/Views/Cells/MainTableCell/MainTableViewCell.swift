//
//  MainTableViewCell.swift
//  testITS
//
//  Created by Daniil Shlapak on 13.01.22.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(name: String, age: String, gender: String){
        self.nameLabel.text = name
        self.ageLabel.text = "Age: \(age)"
        self.genderLabel.text = "Gender: \(gender)"
    }

}

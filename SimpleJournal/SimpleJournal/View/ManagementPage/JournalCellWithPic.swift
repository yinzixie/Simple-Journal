//
//  JournalCell.swift
//  SimpleJournal
//
//  Created by yinzixie on 14/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class JournalCellWithPic: UITableViewCell {

    @IBOutlet var BackGroundCardView: UIView!
    
    @IBOutlet var YearLabel: UILabel!
    @IBOutlet var DateLabel: UILabel!
    @IBOutlet var MonthLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var ContentLabel: UITextView!
    @IBOutlet var MoodView: UIImageView!
    @IBOutlet var ImageView: UIImageView!
    
    @IBOutlet var WeatherView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        BackGroundCardView.backgroundColor = UIColor.white
        BackGroundCardView.layer.cornerRadius = 3.0
        BackGroundCardView.layer.masksToBounds = false
        BackGroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
         BackGroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
         BackGroundCardView.layer.shadowOpacity = 0.8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

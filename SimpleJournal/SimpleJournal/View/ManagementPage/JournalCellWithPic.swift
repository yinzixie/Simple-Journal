//
//  JournalCell.swift
//  SimpleJournal
//
//  Created by yinzixie on 14/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class JournalCellWithPic: UITableViewCell {

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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

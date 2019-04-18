//
//  HomeJournalCell.swift
//  SimpleJournal
//
//  Created by yinzixie on 16/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class HomeJournalCell: UITableViewCell {

    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var MonthLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var ContentLabel: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

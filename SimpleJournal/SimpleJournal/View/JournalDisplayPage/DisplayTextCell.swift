//
//  DisplayTextCell.swift
//  SimpleJournal
//
//  Created by yinzixie on 26/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class DisplayTextCell: UITableViewCell {

    @IBOutlet var TextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

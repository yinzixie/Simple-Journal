//
//  AddPicsCell.swift
//  SimpleJournal
//
//  Created by yinzixie on 22/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class AddPicsCell: UITableViewCell {
    var ParentView:UIViewController? = nil
    @IBOutlet var AddPicsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func AddPics(_ sender: Any) {
        
    }
}

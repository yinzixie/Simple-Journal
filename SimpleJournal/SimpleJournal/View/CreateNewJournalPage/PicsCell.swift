//
//  PicsCell.swift
//  SimpleJournal
//
//  Created by yinzixie on 21/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import UIKit

class PicsCell: UITableViewCell {
    var ParentView:UIViewController? = nil
    
    @IBOutlet var ImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.ImageView.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}

